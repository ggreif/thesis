%% -*- mode: LaTeX; compile-command: "mk" -*-
\documentclass[xcolor=svgnames,12pt]{beamer}

\usepackage{haskell}
%include lhs2TeX-extra.fmt

\usepackage{brent}
\usepackage{species}
\usepackage[outputdir=diagrams]{diagrams-latex}
\graphicspath{{images/}}

\renewcommand{\onelinecomment}{\quad--- \itshape}
\renewcommand{\Varid}[1]{{\mathit{#1}}}

\newcommand{\pt}[1]{\ensuremath{#1^{\bullet}}}
\newcommand{\down}{\chi}

% \setbeamertemplate{footline}{\insertframenumber}

\setbeamertemplate{items}[circle]

\mode<presentation>
{
  \usetheme{default}                          % use a default (plain) theme

  \setbeamertemplate{navigation symbols}{}    % don't show navigation
                                              % buttons along the
                                              % bottom
  \setbeamerfont{normal text}{family=\sffamily}

  % XXX remove this before giving actual talk!
  % \setbeamertemplate{footline}[frame number]
  % {%
  %   \begin{beamercolorbox}{section in head/foot}
  %     \vskip2pt
  %     \hfill \insertframenumber
  %     \vskip2pt
  %   \end{beamercolorbox}
  % }

  \AtBeginSection[]
  {
    \begin{frame}<beamer>
      \frametitle{}
      \begin{center}
        {\Huge \insertsectionhead}
      \end{center}
    \end{frame}
  }
}

\defbeamertemplate*{title page}{customized}[1][]
{
  \vbox{}
  \vfill
  \begin{centering}
    \begin{beamercolorbox}[sep=8pt,center,#1]{title}
      \usebeamerfont{title}\inserttitle\par%
      \ifx\insertsubtitle\@@empty%
      \else%
        \vskip0.25em%
        {\usebeamerfont{subtitle}\usebeamercolor[fg]{subtitle}\insertsubtitle\par}%
      \fi%
    \end{beamercolorbox}%
    \vskip1em\par
    {\usebeamercolor[fg]{titlegraphic}\inserttitlegraphic\par}
    \vskip1em\par
    \begin{beamercolorbox}[sep=8pt,center,#1]{author}
      \usebeamerfont{author}\insertauthor
    \end{beamercolorbox}
    \begin{beamercolorbox}[sep=8pt,center,#1]{institute}
      \usebeamerfont{institute}\insertinstitute
    \end{beamercolorbox}
    \begin{beamercolorbox}[sep=8pt,center,#1]{date}
      \usebeamerfont{date}\insertdate
    \end{beamercolorbox}
  \end{centering}
  \vfill
}

% uncomment me to get 4 slides per page for printing
% \usepackage{pgfpages}
% \pgfpagesuselayout{4 on 1}[uspaper, border shrink=5mm]

% \setbeameroption{show only notes}

\renewcommand{\emph}{\textbf}

\title{Combinatorial Species and Algebraic Data Types}
\date{Dissertation Proposal \\ March 2, 2013}
\author{Brent Yorgey}
\titlegraphic{}  % \includegraphics[width=2in]{foo}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{document}

\begin{frame}[fragile]
   \titlepage
   \hfill \includegraphics[width=0.5in]{plclub}
\end{frame}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{frame}{Outline}
  \begin{itemize}
  \item History
  \item Algebraic data types
  \item Combinatorial species
  \item Species types
  \item The \pkg{species} library
  \item Timeline
  \end{itemize}
\end{frame}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{History}
\label{sec:history}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{frame}{Before species\dots}
  \begin{itemize}
  \item Collections of techniques for dealing with combinatorial objects
  \item Largely centered around \emph{generating functions} (XXX cite
    EC, gfology -- note Herb Wilf)
  \item All rather ad-hoc.
  \end{itemize}
\end{frame}

\begin{frame}{Species!}
  Andr\'e Joyal, 1980 XXX -- ``Une ???''

  XXX picture of first page of Joyal's actual thesis???
\end{frame}

\begin{frame}{Species!}
  XXX picture of BLL?
\end{frame}

\begin{frame}{Species and computer science}
  XXX have to talk about history of people combining species + CS, to
  argue why this is worthwhile

  \begin{itemize}
  \item Flajolet, Salvy, \& Zimmermann --- LUO, combinat
  \item Carette \& Uszkay
  \item Joachim Kock --- XXX
  \end{itemize}
\end{frame}

\begin{frame}{Species and ADTs?}
  \begin{center}
    The connection is ``obvious''. \bigskip

    \onslide<2->
    \dots but what can we do with it? \bigskip

    \onslide<3->
    \emph{A beautiful Answer in search of a Question.}
  \end{center}
\end{frame}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Algebraic data types}
\label{sec:ADTs}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{frame}{Algebraic data types}

  \begin{center}
\includegraphics[width=1in]{ocaml-logo} \hspace{1in}
\includegraphics[width=1in]{haskell-logo}
  \end{center}

\begin{itemize}
\item Base types (|Int|, |Char|, \dots)
\item Unit type ( |Unit| )
\item Sum types (tagged union, |Either|)
\item Product types (tupling, |Pair|)
\item Recursion
\end{itemize}

\onslide<2->
\begin{center}
  Note: no arrow types in this talk!
\end{center}
XXX if time, draw a little arrow with a slash through it =)
\end{frame}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{frame}[fragile]{ADT example}
  Binary tree type:

%format Tree  = "\tycon{Tree}"
%format Empty = "\con{Empty}"
%format Node  = "\con{Node}"

XXX draw tree here
  % \begin{diagram}[width=100]

  % \end{diagram}

  \begin{spec}
data Tree
  =  Empty
  |  Node Tree Int Tree
  \end{spec}

  \begin{spec}
type Tree = Either () (Tree, (Int, Tree))
  \end{spec}

\[ T = 1 + T \times |Int| \times T \]
\end{frame}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{frame}{The fruits of algebra}
  \begin{center}
    \includegraphics[width=2in]{orange-tree}
  \end{center}

  \begin{itemize}
  \item Initial algebra semantics, folds, ``origami'' programming
  \item Generic programming
  \item Connections to algebra and calculus (e.g. zippers)
  \end{itemize}
\end{frame}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Combinatorial species}
\label{sec:species}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \begin{frame}
%   \emph{What are species, and what do they have to do with programming languages?}

%   XXX picture

%   A theory of \emph{labeled structures}
% \end{frame}

\begin{frame}{Species}
  \begin{center}
    The theory of combinatorial species is a theory of \\
    \emph{labeled structures}.
  \end{center}
  XXX picture here of a bunch of example labeled structures.
\end{frame}

\begin{frame}{Species definition}
  \begin{center}

  Big idea: structures \emph{indexed by size}.

  XXX diagram here of binary tree structures by size.

  Gives us all kinds of traction. XXX rephrase
\end{center}
\end{frame}

\begin{frame}{Species definition}
  Better idea (Joyal's key insight): index by \emph{labels} and insist
  the \emph{particular labels used don't matter}.

  XXX diagram of labeled binary tree structures

  \note{note also distinct labelings.  This is a feature, not a bug ---
  allows to seamlessly talk about non-regular structures as well as
  ``unlabelled'' structures.}
\end{frame}

\begin{frame}{Species definition}
  A \term{species} $F$ is a pair of mappings which
\begin{itemize}
\item<2-> sends any finite set $U$ (of \term{labels}) to a finite set
  $F[U]$ (of \term{structures}), and
\item<3-> sends any bijection on finite sets $\sigma : U \bij V$ (a
  \term{relabeling}) to a function $F[\sigma] : F[U] \to F[V]$
\end{itemize}
\onslide<4->
satisfying the following functoriality conditions:
\begin{itemize}
\item $F[id_U] = id_{F[U]}$, and
\item $F[\sigma \circ \tau] = F[\sigma] \circ F[\tau]$.
\end{itemize}
\onslide<5->
\begin{center}
  (Functors from $\B$ to $\FinSet$.)
\end{center}
\end{frame}

\begin{frame}{Relabeling}
  \begin{center}
    \includegraphics{relabeling}
  \end{center}
\end{frame}

\begin{frame}[fragile]{Examples}
\begin{center}
    \begin{diagram}[width=300]
import Species
import Data.List
import Data.List.Split

dia =
  hcat' with {sep = 0.5}
  [ unord (map labT [0..2])
  , arrow 2 (txt "L")
  , enRect listStructures
  ]
  # centerXY
  # pad 1.1

drawList = hcat . intersperse (arrow 0.4 mempty) . map labT

listStructures =
    hcat' with {sep = 0.7}
  . map (vcat' with {sep = 0.5})
  . chunksOf 2
  . map drawList
  . permutations
  $ [0..2]
    \end{diagram}
%$
\end{center}
\end{frame}

\begin{frame}[fragile]{Examples}
  \begin{center}
\begin{diagram}[width=300]
import Species
import Data.Tree
import Diagrams.TwoD.Layout.Tree
import Control.Arrow (first, second)

dia =
  hcat' with {sep = 0.5}
  [ unord (map labT [0..2])
  , arrow 2 (txt "T")
  , enRect treeStructures
  ]
  # centerXY
  # pad 1.1

drawTreeStruct = renderTree id (~~) . symmLayout . fmap labT

trees []   = []
trees [x]  = [ Node x [] ]
trees xxs  = [ Node x [l,r]
             || (x,xs) <- select xxs
             , (ys, zs) <- subsets xs
             , l <- trees ys
             , r <- trees zs
             ]

select []     = []
select (x:xs) = (x,xs) : (map . second) (x:) (select xs)

subsets []     = [ ([],[]) ]
subsets (x:xs) = (map . first) (x:) ss ++ (map . second) (x:) ss
  where ss = subsets xs

treeStructures =
    hcat' with {sep = 0.5}
  . map drawTreeStruct
  . trees
  $ [0..2]
\end{diagram}
%$
  \end{center}
\end{frame}

\begin{frame}[fragile]{Examples}
  XXX cycles
\end{frame}

\begin{frame}[fragile]{Examples}
  XXX simple graphs?
\end{frame}

\begin{frame}
  XXX Vennish diagram showing just species + ADTs.  Say, species is
  too big.
\end{frame}

\begin{frame}
  XXX Vennish diagram showing species, algebra of species, ADTs.
\end{frame}

\begin{frame}{Algebraic species}
  \begin{columns}[t]
    \begin{column}{0.5 \textwidth}
      Primitive species:
      \begin{itemize}
      \item $\Zero$
      \item $\One$
      \item $\X$
      \item $\Cyc$
      \item $\E$
      \item \dots
      \end{itemize}
    \end{column}
    \begin{column}{0.5 \textwidth}
      Species operations:
      \begin{itemize}
      \item $F + G$
      \item $F \sprod G$
      \item $F \comp G$
      \item $F \times G$
      \item $F'$
      \item $\pt{F}$
      \item $F \fcomp G$
      \item \dots
      \end{itemize}
    \end{column}
\end{columns}
\end{frame}

\begin{frame}
  XXX how much detail to drill into here?
\end{frame}

\begin{frame}{Algebraic species example}
  XXX give simple graphs as an example.

  \[ \mathcal{G} = (\E \sprod \E) \fcomp
  (\X^2 \sprod \E) \]
\end{frame}

\begin{frame}
  XXX homomorphism to gen funcs.  Describe, state advantages.
\end{frame}

\begin{frame}
  Presentation will be a contribution of my thesis.

  XXX picture of BLL -- not accessible, expensive

  \includegraphics[width=1in]{BLL-cover}
\end{frame}

\begin{frame}{Exposition: remaining work}
  XXX have begun with blog posts + proposal document
  XXX stuff still remaining:
  \begin{itemize}
    \item $\mathbb{L}$-species
    \item Virtual species
    \item Molecular and atomic species
    \item \dots
  \end{itemize}
\end{frame}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Species types}
\label{sec:species-types}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{frame}
  \begin{center}
    \emph{Can we use the theory of species as a foundational basis for
      container types?}
  \end{center}
\end{frame}

\begin{frame}{What would we need?}
  \begin{itemize}
  \item Formal way to interpret species as data types
  \item Introduction and elimination forms
  \item Generic programming
  \item \dots?
  \end{itemize}
\end{frame}

\subsection{XXX relationship}
\label{sec:relationship}

\begin{frame}{Relationship of species to data types}
  XXX explain here.  From proposal.
\end{frame}

\subsection{Eliminators for species types}
\label{sec:elim}

\begin{frame}[fragile]{Symmetry}
  % Symmetric structure examples: cycles, bags, hierarchies,
  % heaps\dots
  \begin{center}
  \begin{diagram}[width=75]
import Species
dia = cyc [0..4] 1.2 # pad 1.1
  \end{diagram}
  % XXX vertically center, if time
  \begin{diagram}[width=60]
import Species
dia = ( roundedRect 2 1 0.2
        <> (lab 0 |||||| strutX 0.3 |||||| lab 3)
           # centerXY
      )
      # pad 1.1
      # lw 0.02
  \end{diagram}
  \begin{diagram}[width=75]
import Species
import Data.Tree
t   = Node Bag [lf (Lab 1), lf (Lab 2), Node Bag [lf (Lab 0), lf (Lab 3)]]
dia = drawSpT t # pad 1.1
  \end{diagram}
  \bigskip

  XXX fix the rightmost one

  \onslide<2>\dots how can we program with these?
  \end{center}
\end{frame}

\begin{frame}[fragile]{Eliminating symmetries?}
  \begin{center}
  \begin{diagram}[width=200]
import Species
dia = (cyc [0..4] 1.2 ||-|| elimArrow ||-|| (text "?" <> square 1 # lw 0)) # pad 1.1
  \end{diagram}
  \end{center}
  \begin{center}
    \onslide<2>Want a compiler guarantee that eliminators are
    oblivious to ``representation details''.
  \end{center}
\end{frame}

\begin{frame}
  We can build eliminators in a type-directed way, using ``high
  school algebra'' laws for exponents:
  \begin{center}
    \begin{tabular}{ccc}
      $1[A] \to B$ & $\cong$ & $B$ \\
      \\
      $X[A] \to B$ & $\cong$ & $A \to B$ \\
      \\
      $(F+G)[A] \to B$ & $\cong$ & $(F[A] \to B) \times (G[A] \to B)$ \\
      \\
      $(F \cdot G)[A] \to B$ & $\cong$ & $F[A] \to (G[A] \to B)$ \\
    \end{tabular}
  \end{center}
\end{frame}

\begin{frame}{Eliminating symmetries}
  \begin{gather*}
    (X^n/\mathcal{H})[A] \to B \\
    \cong \\
    \Sigma f : X^n \to B. \Pi \sigma \in \mathcal{H}. f = f \circ \sigma
  \end{gather*}
\end{frame}

\subsection{Eliminators, take 2}
\label{sec:elim2}

\begin{frame}{Eliminators, take 2}
  XXX signposting here
\end{frame}

\begin{frame}[fragile]{Poking and pointing}
  The \emph{derivative} $F'$ of $F$ represents $F$-structures with a
  hole.

  \begin{center}
  \begin{diagram}[width=100]
    import Species
    dia = drawSpT (nd 'F' (map lf [Leaf, Hole, Leaf, Leaf])) # pad 1.1
  \end{diagram}
  \end{center}

  The \emph{pointing} of $F$, $\pt{F} \triangleq X \cdot F'$,
  represents $F$-structures with a distinguished element.

  \begin{center}
  \begin{diagram}[width=100]
    import Species
    dia = drawSpT (nd 'F' (map lf [Leaf, Point, Leaf, Leaf])) # pad 1.1
  \end{diagram}
  \end{center}

  \onslide<2> Pointing \emph{breaks symmetry}.
\end{frame}

\begin{frame}[fragile]{Pointing}
  \begin{center}
  \begin{diagram}[width=250]
    import Species
    f   = drawSpT (nd 'F' (map lf [Leaf, Leaf, Leaf, Leaf])) # pad 1.1
    fpt = drawSpT (nd 'F' (map lf [Point, Leaf, Leaf, Leaf])) # pad 1.1

    dia = [f, elimArrow, fpt] # map centerY # foldr1 (||-||)
  \end{diagram}
  \end{center}

  \[ \pt{(-)} : F \to \pt{F} ? \]

  \begin{center}
  \onslide<2>\emph{Only} for polynomials!
  \end{center}
\end{frame}

\begin{frame}[fragile]{Pointing in context}
  \dots but Peter Hancock's ``cursor down'' operator is fine: \[ \down
  : F \to F \pt{F} \]

  \begin{diagram}[width=300]
    import Species
    c = Cyc [lab 0, lab 2, lab 3]
    d1 = draw c
    d2 = draw (down c)
    dia = (d1 ||-|| elimArrow ||-|| d2) # pad 1.05
  \end{diagram}
\end{frame}

\begin{frame}[fragile]{Eliminating with $\down$}
  \begin{diagram}[width=300]
    import Species
    c = Cyc [lab 0, lab 2, lab 3]
    d1 = draw c
    d2 = draw (down c)
    d3 = draw (Cyc (replicate 3 d4))
    d4 :: Diagram Cairo R2
    d4 = square 1 # fc purple
    x ||/|| y = x |||||| strutX 0.5 |||||| y
    t s = (text s <> strutY 1.3) # scale 0.5
    dia = (d1 ||/||
               arrow 1 (t "χ") ||/||
           d2 ||/||
               arrow 1 (t "F e'") ||/||
           d3 ||/||
               arrow 1 (t "δ") ||/||
           d4
          )
          # pad 1.05
  \end{diagram}
\end{frame}

\begin{frame}[fragile]{Other uses of $\down$}
  \begin{diagram}[width=300]
    import Species
    c = Cyc (map lab' [blue, red, yellow])
    d1 = draw c
    d2 = draw (down c)
    d3 = draw (fmap firstTwo (down c))
    d4 = draw (Cyc (map lab' [purple, orange, green]))
    firstTwo = map unPoint . take 2 . dropWhile isPlain . cycle . getCyc
    isPlain (Plain x) = True
    isPlain _         = False
    unPoint (Plain x) = x
    unPoint (Pointed x) = x
    t s = (text s <> strutY 1.3) # scale 0.5
    x ||/|| y = x |||||| strutX 0.5 |||||| y
    infixl 6 ||/||
    dia = (
          ( d1 ||/||
              arrow 1 (t "χ") ||/||
            d2 ||/||
              arrow 3 (t "F (id × head)" # scale 0.8)
          )
          ===
          strutY 1
          ===
          ( square 1 # lw 0 ||/||
            d3 ||/||
              arrow 1 (t "F ⊕") ||/||
            d4
          )

          )
          # pad 1.05
  \end{diagram}
\end{frame}

\begin{frame}{Species types: remaining work}
  \begin{itemize}
  \item Introduction forms
  \item Relate two formulations of eliminators
  \item Extend theory to multi-sort species and recursive species
  \item Make all of this practical for programming
  \end{itemize}
\end{frame}

\begin{frame}{What if something goes wrong?}
  XXX need to address that concern here.
\end{frame}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{The \pkg{species} library}
\label{sec:species-lib}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{frame}
  \emph{XXX need a question here}
\end{frame}

\begin{frame}
  XXX describe library (show screencap of Hackage page)
\end{frame}

\begin{frame}{Example}
{\small
\begin{verbatim}
>>> take 10 . labeled $ set `o` nonEmpty sets
[1,1,2,5,15,52,203,877,4140,21147]

>>> take 10 . unlabeled $ set `o` nonEmpty sets
[1,1,2,3,5,7,11,15,22,30]

>>> enumerate (set `o` nonEmpty sets) [1,2,3]
      :: [(Set :.: Set) Int]
[{{1,2,3}},{{2,3},{1}},{{2},{1,3}},
 {{3},{1,2}},{{3},{2},{1}}]
\end{verbatim}
}
\end{frame}

\begin{frame}
  XXX proposed feature: random generation

% One major missing feature of the library which I propose to add is the
% ability to randomly generate structures of user-defined data types,
% perhaps in concert with an existing test-generation framework such as
% FEAT~\citep{duregaard2012feat} or gencheck~\citep{gencheck}.  In
% particular, no existing frameworks can randomly generate structures
% corresponding to non-regular (symmetric) species.
\end{frame}

\begin{frame}
  XXX typed setting?
\end{frame}

\begin{frame}
  XXX testbed for ideas from previous sections

%   Second, the library can serve as a testbed for the ideas outlined in
% \pref{sec:species-as-data-types}---instead of implementing an entirely
% new programming language from scratch, to a large extent we can simply
% \emph{embed} a new language as a library in Haskell.
\end{frame}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Timeline}
\label{sec:timeline}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{frame}
XXX March--August 2013
% \textbf{March--August 2013}: my focus during this period will be
% twofold: to develop an exposition of species theory, both through my
% blog and in a form suitable to eventually go in my dissertation; and,
% in parallel, to work out a theory of species data types as outlined in
% \pref{sec:species-as-data-types}.
\end{frame}

\begin{frame}
XXX September--December 2013
% \textbf{September--December 2013}: My focus during this period will be
% on development of the \texttt{species} library, as outlined in
% \pref{sec:species-library}.
\end{frame}

\begin{frame}
XXX January--April 2014
% \textbf{January--April 2014} My focus during the first part of 2014
% will be on writing my dissertation, with the goal of defending in May.
\end{frame}

\begin{frame}
  XXX concluding slide
\end{frame}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% \begin{frame}
%   \begin{center}
%     \vspace{1em}
%     Joint work (in progress) with: \bigskip

%     \begin{tabular}{cc}
%     \includegraphics[height=1in]{jacques}
%     & \includegraphics[height=1in]{gershom} \\
%     Jacques Carette & Gershom Bazerman
%     \end{tabular}
%   \end{center}
% \end{frame}

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \begin{frame}{Combinatorial species}
% \begin{center}
%     \onslide<2->{\vfill{\Large ?}\vfill}
%     \onslide<3>{For today: think ``container types'', \emph{i.e.} functors.}
% \end{center}
% \end{frame}

% %% Idea: use them as basis for programming.  First steps: eliminators.

% \begin{frame}[fragile]{Polynomial functors}
%   \begin{center}
%   \begin{tabular}{cl}
%     $1$ & unit\\
%     $X$ & identity \\
%     $F + G$ & sums \\
%     $F \cdot G$ & products
%   \end{tabular}
%   \end{center}

%   \begin{center}
%     \onslide<2-> \emph{e.g.} $1 + X$, $X^2$, \dots

%     \onslide<3> \vspace{1em} No symmetry!
%   \end{center}
% \end{frame}

% \begin{frame}[fragile]{Symmetry}
%   % Symmetric structure examples: cycles, bags, hierarchies,
%   % heaps\dots
%   \begin{center}
%   \begin{diagram}[width=75]
% import Species
% dia = cyc [0..4] 1.2 # pad 1.1
%   \end{diagram}
%   % XXX vertically center, if time
%   \begin{diagram}[width=60]
% import Species
% dia = ( roundedRect 2 1 0.2
%         <> (lab 0 |||||| strutX 0.3 |||||| lab 3)
%            # centerXY
%       )
%       # pad 1.1
%       # lw 0.02
%   \end{diagram}
%   \begin{diagram}[width=75]
% import Species
% import Data.Tree
% t   = Node Bag [lf (Lab 1), lf (Lab 2), Node Bag [lf (Lab 0), lf (Lab 3)]]
% dia = drawSpT t # pad 1.1
%   \end{diagram}
%   \bigskip

%   \onslide<2>\dots how can we program with these?
%   \end{center}
% \end{frame}

% \begin{frame}[fragile]{Eliminating symmetries?}
%   \begin{center}
%   \begin{diagram}[width=200]
% import Species
% dia = (cyc [0..4] 1.2 ||-|| elimArrow ||-|| (text "?" <> square 1 # lw 0)) # pad 1.1
%   \end{diagram}
%   \end{center}

%   \onslide<2>Want: compiler guarantee that eliminators are oblivious
%   to ``representation details''.
% \end{frame}

% \begin{frame}{Species decomposition}
%     Every nonempty species is isomorphic to
%     \begin{itemize}
%     \item<+-> the unit species,
%     \item<+-> a sum,
%     \item<+-> a product,
%     \item<+-> or an \emph{atomic} species $X^n/\mathcal{H}$
%       \begin{itemize}
%       \item<+-> (where $\mathcal{H}$ acts transitively on $\{0, \dots,
%         n-1\}$).
%       \end{itemize}
%   \end{itemize}
% \end{frame}

% \begin{frame}
%   So we can build eliminators in a type-directed way, using ``high
%   school algebra'' laws for exponents:
%   \begin{center}
%     \begin{tabular}{ccc}
%       $1[A] \to B$ & $\cong$ & $B$ \\
%       \\
%       $X[A] \to B$ & $\cong$ & $A \to B$ \\
%       \\
%       $(F+G)[A] \to B$ & $\cong$ & $(F[A] \to B) \times (G[A] \to B)$ \\
%       \\
%       $(F \cdot G)[A] \to B$ & $\cong$ & $F[A] \to (G[A] \to B)$ \\
%       \onslide<2> & & \\
%       $(X^n/\mathcal{H})[A] \to B$ & $\cong$ & $ ?$
%     \end{tabular}
%   \end{center}
% \end{frame}

% \begin{frame}{Eliminating symmetries}
%   \begin{gather*}
%     (X^n/\mathcal{H})[A] \to B \\
%     \cong \\
%     \Sigma f : X^n \to B. \Pi \sigma \in \mathcal{H}. f = f \circ \sigma
%   \end{gather*}
% \end{frame}

% \section{Eliminators, take 2!}

% \begin{frame}[fragile]{Poking and pointing}
%   The \emph{derivative} $F'$ of $F$ represents $F$-structures with a
%   hole.

%   \begin{center}
%   \begin{diagram}[width=100]
%     import Species
%     dia = drawSpT (nd 'F' (map lf [Leaf, Hole, Leaf, Leaf])) # pad 1.1
%   \end{diagram}
%   \end{center}

%   The \emph{pointing} of $F$, $\pt{F} \triangleq X \cdot F'$,
%   represents $F$-structures with a distinguished element.

%   \begin{center}
%   \begin{diagram}[width=100]
%     import Species
%     dia = drawSpT (nd 'F' (map lf [Leaf, Point, Leaf, Leaf])) # pad 1.1
%   \end{diagram}
%   \end{center}

%   \onslide<2> Pointing \emph{breaks symmetry}.
% \end{frame}

% \begin{frame}[fragile]{Pointing}
%   \begin{center}
%   \begin{diagram}[width=250]
%     import Species
%     f   = drawSpT (nd 'F' (map lf [Leaf, Leaf, Leaf, Leaf])) # pad 1.1
%     fpt = drawSpT (nd 'F' (map lf [Point, Leaf, Leaf, Leaf])) # pad 1.1

%     dia = [f, elimArrow, fpt] # map centerY # foldr1 (||-||)
%   \end{diagram}
%   \end{center}

%   \[ \pt{(-)} : F \to \pt{F} ? \]

%   \begin{center}
%   \onslide<2>\emph{Only} for polynomials!
%   \end{center}
% \end{frame}

% \begin{frame}[fragile]{Pointing in context}
%   \dots but Peter Hancock's ``cursor down'' operator is fine: \[ \down
%   : F \to F \pt{F} \]

%   \begin{diagram}[width=300]
%     import Species
%     c = Cyc [lab 0, lab 2, lab 3]
%     d1 = draw c
%     d2 = draw (down c)
%     dia = (d1 ||-|| elimArrow ||-|| d2) # pad 1.05
%   \end{diagram}
% \end{frame}

% \begin{frame}[fragile]{Eliminating with $\down$}
%   \begin{diagram}[width=300]
%     import Species
%     c = Cyc [lab 0, lab 2, lab 3]
%     d1 = draw c
%     d2 = draw (down c)
%     d3 = draw (Cyc (replicate 3 d4))
%     d4 :: Diagram Cairo R2
%     d4 = square 1 # fc purple
%     x ||/|| y = x |||||| strutX 0.5 |||||| y
%     t s = (text s <> strutY 1.3) # scale 0.5
%     dia = (d1 ||/||
%                arrow 1 (t "χ") ||/||
%            d2 ||/||
%                arrow 1 (t "F e'") ||/||
%            d3 ||/||
%                arrow 1 (t "δ") ||/||
%            d4
%           )
%           # pad 1.05
%   \end{diagram}
% \end{frame}

% \begin{frame}[fragile]{Other uses of $\down$}
%   %% XXX 4  -- draw example of another thing "down" is useful for
% %  Note $\down$ is useful for other things too. ``Map in context''.
% %  e.g. cycles.
%   \begin{diagram}[width=300]
%     import Species
%     c = Cyc (map lab' [blue, red, yellow])
%     d1 = draw c
%     d2 = draw (down c)
%     d3 = draw (fmap firstTwo (down c))
%     d4 = draw (Cyc (map lab' [purple, orange, green]))
%     firstTwo = map unPoint . take 2 . dropWhile isPlain . cycle . getCyc
%     isPlain (Plain x) = True
%     isPlain _         = False
%     unPoint (Plain x) = x
%     unPoint (Pointed x) = x
%     t s = (text s <> strutY 1.3) # scale 0.5
%     x ||/|| y = x |||||| strutX 0.5 |||||| y
%     infixl 6 ||/||
%     dia = (
%           ( d1 ||/||
%               arrow 1 (t "χ") ||/||
%             d2 ||/||
%               arrow 3 (t "F (id × head)" # scale 0.8)
%           )
%           ===
%           strutY 1
%           ===
%           ( square 1 # lw 0 ||/||
%             d3 ||/||
%               arrow 1 (t "F ⊕") ||/||
%             d4
%           )

%           )
%           # pad 1.05
%   \end{diagram}
% \end{frame}

% \begin{frame}
%   Future work:
%   \begin{itemize}
%   \item What do proof obligations for eliminators with $\down$ look
%     like in practice?
%   \item Relationship to quotient containers?
%   \end{itemize}
% \end{frame}
\end{document}
