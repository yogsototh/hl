{-# LANGUAGE OverloadedStrings #-}

-- | Downloads page view.

module HL.View.Downloads where

import Data.Monoid
import HL.Types
import HL.View
import HL.View.Template

stackSection :: (Route App -> Text) -> Html ()
stackSection url = do
  p_ $ do
    "For most development, you'll need both the "
    b_ "Glasgow Haskell Compiler (GHC)"
    " and a build tool. The "
    b_ "Stack build tool"
    " can download GHC and other necessary Haskell dependencies for you on demand. "
    "You may also choose an installer package, which includes GHC and build tools."

  ul_ $ do
    li_ $ (a_ [href_ "https://github.com/yogsototh/stack/blob/master/doc/QUICKSTART.md"] "Read the stack guide →")
    li_ $ a_ [href_ "#choosing"] "Help me choose the right download →"

  h2_ [id_ "download-stack"] "Download stack"
  ul_ $ do
    li_ $ a_ [href_ "https://github.com/commercialhaskell/stack/blob/master/doc/install_and_upgrade.md#windows"] "Windows"
    li_ $ a_ [href_ "https://github.com/commercialhaskell/stack/blob/master/doc/install_and_upgrade.md#os-x"] "OS X"
    li_ $ a_ [href_ "https://github.com/commercialhaskell/stack/blob/master/doc/install_and_upgrade.md#ubuntu"] "Ubuntu"
    li_ $ a_ [href_ "https://github.com/commercialhaskell/stack/blob/master/doc/install_and_upgrade.md#debian"] "Debian"
    li_ $ a_ [href_ "https://github.com/commercialhaskell/stack/blob/master/doc/install_and_upgrade.md#centos--red-hat--amazon-linux)"] "CentOS / Red Hat / Amazon Linux"
    li_ $ a_ [href_ "https://github.com/commercialhaskell/stack/blob/master/doc/install_and_upgrade.md#fedora"] "Fedora"
    li_ $ a_ [href_ "https://github.com/commercialhaskell/stack/blob/master/doc/install_and_upgrade.md#nixos"] "NixOS"
    li_ $ a_ [href_ "https://github.com/commercialhaskell/stack/blob/master/doc/install_and_upgrade.md#arch-linux"] "Arch Linux"
    li_ $ a_ [href_ "https://github.com/commercialhaskell/stack/blob/master/doc/install_and_upgrade.md#linux"] "Linux (general)"
  p_ (a_ [href_ "https://github.com/commercialhaskell/stack/blob/master/doc/install_and_upgrade.md#upgrade"] "Upgrade instructions")

  -- Note: once Haskell Platform begins shipping with stack and without global
  -- packages, it should take over this section.
  h2_ [id_ "download-installer"] "Installers including the GHC compiler"
  ul_ $ do
    li_ $ do
      "Windows: "
      a_ [href_ "https://github.com/fpco/minghc/releases"] "MinGHC"
    li_ $ do
      "OS X (10.9 or later): "
      a_ [href_ "http://ghcformacosx.github.io/"] "GHC for Mac OS X"
    li_ $ do
      "Linux: "
      a_ [href_ $ url $ DownloadsForR Linux] "Manual installation instructions"

  p_ "Note: On Windows, both Stack and installers provide MSYS2, which is necessary for building some Haskell packages that rely upon autotools configuration"

  h2_ [id_ "choosing"] "Choosing a download route"

  p_ "Download Stack directly when:"
  ul_ $ do
    li_ "You don't know which GHC version you need, or may want to use multiple versions"
    li_ "You want a simple upgrade path for your build tools"
    li_ "You want to minimize the number of tools added to your executable search path"
    li_ $ a_ [href_ "#download-stack"] "Download Stack now →"
  p_ "Download an installer package when:"
  ul_ $ do
    li_ "You intend to use cabal-install instead of Stack"
    li_ "You don't want your build tool to download your compiler for you"
    li_ "You'll be reusing the downloaded file to install on multiple machines"
    li_ "You want GHC and other tools to be on your executable search path"
    li_ $ a_ [href_ "#download-installer"] "Download an installer now →"

  h2_ "What's next?"
  ul_ $ do
    li_ $ (a_ [href_ "https://github.com/commercialhaskell/stack/blob/master/doc/GUIDE.md"] "Read the stack guide →")
    li_ $ (a_ [href_ "https://hackage.haskell.org/packages/"] $ "Browse available packages on Hackage →")

hpSection :: Html ()
hpSection = do
  let hpRoot = "http://www.haskell.org/platform/"
  h2_ "Haskell Platform"
  p_ $ "The Haskell Platform is a convenient way to install the Haskell development tools and"
       <> " a collection of commonly used Haskell packages from Hackage."
  p_ "Advantages:"
  ul_ $ do
    li_ "You get more libraries available immediately, without needing to install them"
    li_ "The libraries installed represent a \"blessed subset\" of available packages, known to be best-in-class"
  p_ "Disadvantages:"
  ul_ $ do
    li_ "The presence of additional packages can sometimes create difficulties with upgrading those packages"
    li_ "The download does not currently include the Stack build tool, only cabal-install"
  p_ "Note: both disadvantages are being worked on currently, and will be addressed in the next release"
  p_ $ "Get the Haskell Platform for:"
  ul_ $ do li_ $ a_ [href_ $ hpRoot <> "windows.html"] "Windows"
           li_ $ a_ [href_ $ hpRoot <> "mac.html"] "OS X"
           li_ $ a_ [href_ $ hpRoot <> "linux.html"] "Linux"

-- | Downloads view.
downloadsV :: FromLucid App
downloadsV =
  template [] "Downloads"
    (\url ->
       container_
         (row_
            (span12_ [class_ "col-md-12"]
               (do h1_ "Downloads"
                   stackSection url
                   hpSection))))

-- | OS-specific downloads view.
downloadsForV :: OS -> Html () -> Html () -> FromLucid App
downloadsForV os autoInstall manualInstall =
  template
    [DownloadsR
    ,DownloadsForR os]
    ("Downloads for " <> toHuman os)
    (\_ ->
       container_
         (row_
            (span12_ [class_ "col-md-12"]
               (do h1_ (toHtml ("Downloads for " <> toHuman os))
                   autoInstall
                   when (os == Linux)
                        (do h2_ "Manual install"
                            p_ "To install GHC and Cabal manually, follow these steps."
                            manualInstall)))))
