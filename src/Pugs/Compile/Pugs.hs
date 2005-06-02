{-# OPTIONS_GHC -cpp -fglasgow-exts -fth #-}

#include "../pugs_config.h"

module Pugs.Compile.Pugs (genPugs) where
import Pugs.AST
import Pugs.Types
import Pugs.Internals
import Text.PrettyPrint
#if !defined(PUGS_HAVE_PERL5) && !defined(PUGS_HAVE_PARROT) && defined(PUGS_HAVE_TH) && (__GLASGOW_HASKELL__ <= 604)
import qualified Language.Haskell.TH as TH
#endif

class (Show x) => Compile x where
    compile :: x -> Eval Doc
    compile x = fail ("Unrecognized construct: " ++ show x)
    compileList :: [x] -> Eval Doc
    compileList = liftM prettyList . mapM compile

instance (Compile x) => Compile [x] where
    compile = compileList

sep1 :: Doc -> Doc -> Doc
sep1 a b = sep [a, b]

prettyList :: [Doc] -> Doc
prettyList = brackets . vcat . punctuate comma

prettyDo :: [Doc] -> Doc
prettyDo docs = parens $ sep (text "do":punctuate semi docs)

#if !defined(PUGS_HAVE_PERL5) && !defined(PUGS_HAVE_PARROT) && defined(PUGS_HAVE_TH) && (__GLASGOW_HASKELL__ <= 604)
prettyRecord :: String -> [(String, Doc)] -> Doc
prettyRecord con = (text con <+>) . braces . sep . punctuate semi . map assign
    where assign (name, val) = text name <+> char '=' <+> val
#endif

prettyBind :: String -> Doc -> Doc
prettyBind var doc = text var `sep1` nest 1 (text "<-" <+> doc)



instance Compile Exp where
    compile (Syn syn exps) = do
        expsC <- compileList exps
        return $ prettyDo
                [ prettyBind "exps" (text "sequence" `sep1` expsC)
                , text "return" <+> parens (text $ "Syn " ++ show syn ++ " exps")
                ]
    compile (Stmts exp1 exp2) = do
        exp1C <- compile exp1
        exp2C <- compile exp2
        return $ prettyDo 
                [ prettyBind "exp1" exp1C
                , prettyBind "exp2" exp2C
                , text "return (Stmts exp1 exp2)"
                ]
    compile (Pad scope pad exp) = do
        padC <- compile pad
        expC <- compile exp
        return $ prettyDo
                [ prettyBind "pad" padC
                , prettyBind "exp" expC
                , text ("return (Pad " ++ show scope ++ " pad exp)")
                ]
    compile exp = return $ text "return" $+$ parens (text $ show exp)

instance Compile Pad where
    compile pad = do
        symsC <- mapM compile syms
        return $ text "fmap mkPad . sequence $ "
            $+$ nest 4 (prettyList $ filter (not . isEmpty) symsC)
        where
        syms = padToList pad

instance Compile (String, [(TVar Bool, TVar VRef)]) where
    compile ((_:'?':_), _) = return empty -- XXX - @?INIT etc; punt for now
    compile ((_:'=':_), _) = return empty -- XXX - @=POS etc; punt for now
    compile (n, tvars) = do
        tvarsC <- compile tvars
        return $ prettyDo 
                [ prettyBind "tvars" (text "sequence" `sep1` tvarsC)
                , text ("return (" ++ show n ++ ", tvars)")
                ]

instance Compile (TVar Bool, TVar VRef) where
    compile (fresh, tvar) = do
        freshC <- compile fresh
        tvarC  <- compile tvar
        return $ prettyDo 
                [ prettyBind "fresh" freshC
                , prettyBind "tvar" tvarC
                , text "return (fresh, tvar)"
                ]

instance Compile (TVar Bool) where
    compile fresh = do
        bool <- liftSTM $ readTVar fresh
        return $ text "liftSTM" <+> parens (text "newTVar" <+> text (show bool))

instance Compile (TVar VRef) where
    compile fresh = do
        vref    <- liftSTM $ readTVar fresh
        vrefC   <- compile vref
        return $ prettyDo            
                [ prettyBind "vref" vrefC
                , text "liftSTM (newTVar vref)"
                ]

instance Compile VRef where
    compile (MkRef (ICode cv)) = do
        vsub <- code_fetch cv
        vsubC <- compile vsub
        return (text "return (MkRef " <> 
                parens (sep [text "ICode $ ", vsubC]) <> text ")")
    compile (MkRef (IScalar sv)) | scalar_iType sv == mkType "Scalar::Const"
                                 = do
        sv <- scalar_fetch sv
        svC <- compile sv
        return (text "return (MkRef " <> 
                parens (sep [text "IScalar $ ", svC]) <> text ")")

    compile ref = do
        return $ text $ "newObject (mkType \"" ++ showType (refType ref) ++ "\")"

instance Compile Val where
    compile (VCode vc) = liftM ((text "VCode" <+>) . parens) $ compile vc
    compile x = return $ text $ show x

-- Haddock can't cope with Template Haskell
instance Compile VCode where
#if !defined(HADDOCK) && !defined(PUGS_HAVE_PERL5) && !defined(PUGS_HAVE_PARROT) && defined(PUGS_HAVE_TH) && (__GLASGOW_HASKELL__ <= 604)
    compile code | subType code == SubPrim = return $ text "mkPrim"
    compile code = do 
        return $ prettyRecord "MkCode" $
            $(liftM TH.ListE $ 
              mapM (\name -> [|(name, tshow $
                                $(TH.varE $ TH.mkName name) code)|]) $
              ["isMulti", "subName", "subType", "subEnv", "subAssoc",
              "subParams", "subBindings", "subSlurpLimit",
              "subReturns", "subLValue", "subCont"])
            ++
            []
        where 
        tshow :: Show a => a -> Doc
        tshow = text . show
#else 
    compile code | subType code == SubPrim = return $ text "mkPrim"
    compile code = return $ text $ show code
#endif 

genPugs :: Eval Val
genPugs = do
    exp     <- asks envBody
    glob    <- askGlobal
    globC   <- compile glob
    expC    <- compile exp
    return . VStr . unlines $
        [ "{-# OPTIONS_GHC -fglasgow-exts -fno-warn-unused-imports -fno-warn-unused-binds -O #-}"
        , "module MainCC where"
        , "import Pugs.Run"
        , "import Pugs.AST"
        , "import Pugs.Types"
        , "import Pugs.Internals"
        , ""
        , "mainCC = do"
        , "    glob <- globC"
        , "    exp  <- expC"
        , "    runAST glob exp"
        , ""
        , renderStyle (Style PageMode 100 0) $ text "globC =" <+> globC
        , ""
        , renderStyle (Style PageMode 100 0) $ text "expC =" <+> expC
        , ""
        ]
