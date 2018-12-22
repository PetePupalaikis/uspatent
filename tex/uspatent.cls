%%
%% This is file `uspatent.cls',
%% 
%%   Author: Peter J. Pupalaikis  (pete_pope  at hotmail dot com)
%%   Copyright 2012,2017 Peter J. Pupalaikis
%%   Version 2.0
%% 
%%   This work may be distributed and/or modified under the
%%   conditions of the LaTeX Project Public License, either
%%   version 1.3 of this license or (at your option) any
%%   later version.
%%   The latest version of the license is in
%%      http://www.latex-project.org/lppl.txt
%%   and version 1.3 or later is part of all distributions of
%%   LaTeX version 2003/06/01 or later.
%% 
%%   This work consists of the files listed in the README file.
%% 

% --------------
% Format Section
% --------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{uspatent}%
  [2016/30/11 v2.0 U.S. Patent Application Class]
%\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
%\ProcessOptions
\LoadClass[letterpaper,12pt]{memoir}[1996/10/24]

% The class option efileReady sets the output to PDF/A
% to enable the output to be validated by the USPTO 
% e-file system.
\DeclareOption{efileReady}{\newcommand{\efileReady}{}}
\ProcessOptions\relax

% -----------------------
% Option Handling Section
% -----------------------

%Options for printing
\newif\ifPatentOfficeMode
\PatentOfficeModetrue

\newif\ifFigureCaptionsOnTop
\FigureCaptionsOnTopfalse

%Commands for setting metadata about the application
\newcommand{\setAssigneeName}{\def\assigneeName}
\newcommand{\setAssigneeAddress}{\def\assigneeAddress}
\newcommand{\setAssigneeCity}{\def\assigneeCity}
\newcommand{\setAssigneePhone}{\def\assigneePhone}
\newcommand{\setDocketNumber}{\def\patentNumber}
\newcommand{\setLawyerName}{\def\patentLawyerName}
\newcommand{\setLawyerNumber}{\def\patentLawyerNumber}
\newcommand{\setLawyerPhone}{\def\patentLawyerPhone}
\newcommand{\setOtherInventor}[1]{\otherInventor{#1}}
\newcommand{\setDocumentVersion}{\def\patentDocumentVersion}
\newcommand{\setPrintingModeDraft}{\PatentOfficeModefalse}
\newcommand{\setPrintingModeApplication}{\PatentOfficeModetrue}
\newcommand{\inventor}{\author}
\newcommand{\setFiguresLocation}[1]{\def\dwgDir{#1}\graphicspath{{#1/}}}
\newcommand{\setFigureCaptionsOnTop}{\FigureCaptionsOnToptrue}

% -------------
% Setup Section
% -------------

%Set up margins and paper sizes
\settrimmedsize{11in}{8.5in}{*}
\setlength{\trimtop}{0pt}
\setlength{\trimedge}{0pt}
\settypeblocksize{8.5in}{36pc}{*}
\setulmargins{1.5in}{*}{*}
\setlrmargins{*}{*}{1}
\setmarginnotes{17pt}{51pt}{\onelineskip}
\setheadfoot{5\onelineskip}{3\onelineskip}
\setheaderspaces{*}{2\onelineskip}{*}
\checkandfixthelayout
\captiondelim{}

% --------
% Packages
% --------

%Set up packages for PDFs
\ifpdf
    \ifdefined\efileReady
        % efileReady mode attempts
        % to include PDF/A compliance to allow direct
        % e-filing at the patent office. Make sure to
        % fill out the PatentApplication.xmpdata file
        % as well.
        % Created from the tutorial at 
        % https://www.mathstat.dal.ca/~selinger/pdfa/
        \usepackage[a-1b]{pdfx}
        \usepackage[pdftex]{graphicx}
        %No Commas in the PDF Title!?!
        \hypersetup{
        hyperindex=true,
        pdfusetitle,
        bookmarks=true,
        extension= pdf,
        linkcolor=black,
        colorlinks=true,
        hyperfootnotes=false,
        pdffitwindow=true,
        pdftoolbar=true,
        pdfmenubar=true,
        debug=false,
        pagebackref=true
        }
        \DeclareGraphicsExtensions{ .pdf, .jpg, .tif}
    \else
        \usepackage[pdftex]{graphicx}
        %No Commas in the PDF Title!?!
        \usepackage[
        hyperindex=true,
        pdfusetitle,
        bookmarks=true,
        extension= pdf,
        linkcolor=black,
        colorlinks=true,
        hyperfootnotes=false,
        pdffitwindow=true,
        pdftoolbar=true,
        pdfmenubar=true,
        debug=false,
        pagebackref=true
        ]{hyperref}
        \DeclareGraphicsExtensions{ .pdf, .jpg, .tif}
    \fi
\else
    \usepackage[dvips]{graphicx}
    \DeclareGraphicsExtensions{ .eps, .jpg }
\fi

%Other required packages
\usepackage{amsmath}
\usepackage{enumitem}
\usepackage[nolist]{acronym}
\usepackage{memhfixc}
\usepackage{xspace}
\usepackage{prettyref}
\usepackage{lmodern}
\usepackage[T1]{fontenc}
\usepackage{babel}
\usepackage{tikz}
\usepackage{pgfplots}
\usepackage[figuresright]{rotating}
\usepackage{listings}
\usepackage{hyphenat}
\usepackage{xstring}
\newcommand{\listingTextSize}{\scriptsize}

\usepackage{listings}
\lstset{basicstyle={\listingTextSize\ttfamily},
    breakautoindent=true,
    breakindent=10pt,
    breaklines=true,
    captionpos=t,
    columns=fixed,
    commentstyle={\listingTextSize\ttfamily},
    extendedchars=true,
    float=hbp,
    identifierstyle={\listingTextSize\ttfamily},
    keywordstyle={\listingTextSize\ttfamily},
    language=Matlab,
    numbers=left,
    numbersep=1em,
    numberstyle={\listingTextSize\ttfamily},
    showspaces=false,
    showstringspaces=false,
    stringstyle={\listingTextSize\ttfamily},
    tabsize=4,
    xleftmargin=1em}

% -----------------
% Reference Formats
% -----------------

\newrefformat{eq}{\textup{(\ref{#1})}}
\newrefformat{cla}{claim \ref{#1}}
\newrefformat{tab}{Table \ref{#1}}
\newrefformat{fig}{\figurename \ \textbf{\ref{#1}}}

% -------------------------
% Title page, headers, etc.
% -------------------------

%The \patentTitlePage command sets up headings and outputs the title page
\newcommand{\patentTitlePage}{%

    %This section sets any undefined fields to nonbreaking space 
    %(~) or another reasonable value to avoid any issues
    \ifx\assigneeName\undefined
        \global\edef\assigneeName{~}
        \global\edef\confidentialAssignee{~}
    \else
        \global\edef\confidentialAssignee{Confidential Property of \assigneeName}
    \fi
    \ifx\assigneeAddress\undefined\global\edef\assigneeAddress{~}\fi
    \ifx\assigneeCity\undefined\global\edef\assigneeCity{~}\fi
    \ifx\assigneePhone\undefined\global\edef\assigneePhone{~}\fi
    \ifx\patentNumber\undefined\global\edef\patentNumber{~}\fi
    \ifx\patentLawyerName\undefined\global\edef\patentLawyerName{~}\fi
    \ifx\patentLawyerNumber\undefined\global\edef\patentLawyerNumber{~}\fi
    \ifx\patentLawyerPhone\undefined\global\edef\patentLawyerPhone{~}\fi
    \ifx\patentDocumentVersion\undefined\global\edef\patentDocumentVersion{0.0}\fi
    %Note that if the date of the draft is left undefined, 
    %it will be set to today's date
    \ifx\thedate\undefined\global\edef\thedate{\today}\fi

    %The following section sets up headings used in application 
    %(patent office) mode
    \ifPatentOfficeMode
        %patent office mode
        \pagestyle{title}
        \makeoddhead{myheadings}
        {}{}{\scriptsize{\patentNumber}}
        \makeevenhead{myheadings}
        {}{}{\scriptsize{\patentNumber}}
    \else
        %This section sets up headings for draft mode
        %not patent office mode
        \pagestyle{title}
        \makeoddhead{myheadings}
        {\confidentialAssignee}
        {}
        {\scriptsize{Draft of \thedate\\version \patentDocumentVersion}}
        \makeevenhead{myheadings}
        {\confidentialAssignee}
        {}
        {\scriptsize{Draft of \thedate\\version \patentDocumentVersion}}
    \fi

    %This section outputs the formatted title page
    \begin{titlingpage}
    \aliaspagestyle{titlingpage}{myheadings}
    \begin{center}
    \textbf{APPLICATION FOR UNITED STATES LETTERS PATENT} 
    \vskip 172 pt
    Title: \MakeUppercase{ \thetitle } 
    \end{center}
    \vskip 172 pt
    \begin{flushleft} \begin{tabular}{rl}  Inventors:  & 
    \theauthor \\
    & \inventorListName{1} \\
    & \inventorListName{2} \\
    & \inventorListName{3} \\
    & \inventorListName{4} \\
    & \inventorListName{5} \\
    & \inventorListName{6} \\
    & \inventorListName{7} \\
    & \inventorListName{8} \\
    \end{tabular}\par \end{flushleft}
    \begin{flushright}
    \tiny{
    \vskip 10 pt
    %\\[4\baselineskip]
    \patentLawyerName \\
    \patentLawyerNumber \\
    [2\baselineskip]
    \assigneeName \\
    \assigneeAddress \\
    \assigneeCity \\
    \assigneePhone
    }
    \end{flushright}
    \end{titlingpage}
    \parindent 10pt
    \DoubleSpacing}

%Set the built in \maketitle to run the previously defined 
%\patentTitlePage command and start the patent
\renewcommand{\maketitle}{
    \patentTitlePage
    \patentStart}

%Set the text of the figure reference
\def\figureName{FIG.}

%If there is more than one inventor, output "et al."
%Otherwise (if a single inventor) don't output anything
\def\etal{%
    \expandafter\ifx\csname inventorname 1\endcsname\relax
    \else ~et~al.%
    \fi}

% Make underscores printable for path output
\newcommand{\printable}[1]{\StrSubstitute{#1}{_}{\_}}

% ---------------
% Document Macros
% ---------------

% use this command to put a comment in the margin
\newcommand{\patentComment}[1]{
    \ifPatentOfficeMode
        %patent office mode
    \else
        %not patent office mode
        \begin{SingleSpace}
        \marginpar{\tiny\textcolor{red}{ \begin{flushleft} #1 \end{flushleft}}}
        \end{SingleSpace}
    \fi}

%This command outputs a heading, which will also be included in
%the output PDF bookmarks
\newcommand{\patentSection}[1]{
    \Needspace{8pc}
    \section[#1][]{}
    %\label{#2}
    \begin{center}
    \textbf{\underline{\MakeUppercase{{#1}}}}
    \end{center}}

%This command begins a paragraph, which will be automatically numbered
\newcommand{\patentParagraph}{
    \par\noindent
    \refstepcounter{parnum}[\textbf{%
    % Add leading zeroes if necessary
    \ifnum \value{parnum} < 10 0\else\fi
    \ifnum \value{parnum} < 100 0\else\fi
    \ifnum \value{parnum} < 1000 0\else\fi
    \arabic{parnum}}]
    \indent}

% ------------------------------
% Output title page and headings
% ------------------------------

%Begin the patent section. Set up some headings, depending on
%whether in application (patent office) mode or draft mode.
\newcommand{\patentStart}{
    \ifPatentOfficeMode
        %patent office mode
        \pagestyle{myheadings}
        \makeoddhead{myheadings}{}{}{\scriptsize{\patentNumber}}
        \makeevenhead{myheadings}{}{}{\scriptsize{\patentNumber}}
        \makeoddfoot{myheadings}{}{\thepage}{}
        \makeevenfoot{myheadings}{}{\thepage}{}
    \else
        %not patent office mode
        \pagestyle{myheadings}
        \makeoddhead{myheadings}
        {\confidentialAssignee}
        {}{\scriptsize{Draft of \thedate\\version \patentDocumentVersion}}
        \makeevenhead{myheadings}
        {\confidentialAssignee}
        {}{\scriptsize{Draft of \thedate\\version \patentDocumentVersion}}
        \makeoddfoot{myheadings}{\thepage}{}{\scshape{\tiny{\thetitle}}}
        \makeevenfoot{myheadings}{\scshape{\tiny{\thetitle}}}{}{\thepage}
    \fi

    %Add the title to the first page
    \begin{center}\textbf{\MakeUppercase{ \thetitle }}\end{center}

    % don't show section numbers!
    \setcounter{secnumdepth}{-1}
    % let them go into the "TOC" (even though we won't print it) because
    % this allows the PDF file to contain the appropriate bookmarks
    \setcounter{tocdepth}{1}

    \setbeforesecskip{0pc}
    \setaftersecskip{0pc}
    \parskip=10pt

    % this is used to number paragraphs
    \newcounter{parnum}}

%Set up a counter for the number of inventors
\makeatletter
\newcount\@inventornumber
\@inventornumber=0
\makeatother

%This macro is used by the \setOtherInventor command to add
%inventors. It increases the count of inventors and makes 
%a macro for each of the form \inventorname 1
\makeatletter
\def\otherInventor#1{
    \global\advance\@inventornumber by 1
    \expandafter\edef\csname inventorname \the\@inventornumber\endcsname{#1}}
\makeatother

%Helper macro to call the \inventorname 1 with the syntax 
%\inventorListName{1}
\def\inventorListName#1{\csname inventorname #1\endcsname}

% ----------------------
% Claim Commands Section
% ----------------------

% Claims are the only area where I still use labels, hence the
% prettyref include.
% \patentClaimsStart essentially begins the enumerate environment and 
% \patentClaimsEnd essentially ends it.
% I'd like to remove this dependency someday and use the counter
% mechanisms used elsewhere.

% Inside, a claim is begin with \beginClaim which labels it and starts
% an \item.
% Claims are referenced with \claimRef
\newcommand{\beginClaim}[1]{\item \label{cla:#1}}
\newcommand{\claimRef}[1]{claim \ref{cla:#1}}

%Defines the text at the beginning of the claims
\newcommand{\WhatIsClaimed}{What is claimed is:}

%Sets up the claims section and outputs the beginning text
\newcommand{\patentClaimsStart}{
    \newpage
    \section[Claims][]{}
    \parskip=0pt
    \WhatIsClaimed
    \begin{enumerate}}

%Ends the claims section
\newcommand{\patentClaimsEnd}{
    \end{enumerate}
    \newpage}

% ----------------
% Drawings section
% ----------------

% Set up the headers and footers
% Patent drawings have a special header that numbers the drawing pages
\newcommand{\patentDrawingsStart}{
    \cleartooddpage
    %\newpage
    \ifPatentOfficeMode
        %patent office mode
        \setcounter{page}{1}
        \pagestyle{myheadings}
        \makeoddhead{myheadings}{}{
        \tiny{\thetitle} \\
        \tiny{\theauthor\etal} \\
        \tiny{\patentNumber} \\
        \tiny{\patentLawyerName\ \patentLawyerPhone}\\[.1in]
        \tiny{\thepage/\thelastpage}
        }{}
        \makeevenhead{myheadings}{}{
        \tiny{\thetitle} \\
        \tiny{\theauthor\etal} \\
        \tiny{\patentNumber} \\
        \tiny{\patentLawyerName\ \patentLawyerPhone}\\[.1in]
        \tiny{\thepage/\thelastpage}
        }{}
        \makeoddfoot{myheadings}{}{}{}
        \makeevenfoot{myheadings}{}{}{}
    \else
        %not patent office mode
        \pagestyle{myheadings}
        \makeoddhead{myheadings}
        {\confidentialAssignee}
        {}
        {\scriptsize{Draft of \thedate\\version \patentDocumentVersion}}
        \makeevenhead{myheadings}
        {\confidentialAssignee}
        {}
        {\scriptsize{Draft of \thedate\\version \patentDocumentVersion}}
        \makeoddfoot{myheadings}{\thepage}{}{\scshape{\tiny{\thetitle}}}
        \makeevenfoot{myheadings}{\scshape{\tiny{\thetitle}}}{}{\thepage}
    \fi

    \section[Drawings][]{}
    \begin{SingleSpace}}
% (End of \patentDrawingsStart command definition)

% Command to end the drawings section
\newcommand{\patentDrawingsEnd}{
    \end{SingleSpace}
    %\newpage
    \clearpage}

% -------------------
% Annotations section
% -------------------

% Set up a counter for annotations, starting at 0
\makeatletter
\newcount\@annotationnumber
\@annotationnumber=0
\makeatother

% Set up a counter called @annotationFigureNumber
% This keeps track of the figure in which each annotation
% is introduced
\makeatletter
\newcount\@annotationfigurenumber
\@annotationfigurenumber=0
\makeatother

\makeatletter
\def\advanceannotationfigurenumber{
    \global\advance\@annotationfigurenumber by 1}
\makeatother

% macro to directly set the current annotation number
% Actually sets it one previous because the first thing
% the \annotationDefinition command does is increment it
\makeatletter
\def\setannotationnumber#1{%
    \global\@annotationnumber=#1
    \global\advance\@annotationnumber by -1}
\makeatother

\def\annotationnextfigure{
    \global\advance\@annotationfigurenumber by 1}

% Directly set the annotation figure number
\makeatletter
\def\setannotationfigurenumber#1{%
    \global\@annotationfigurenumber=#1}
\makeatother

% Command to create a new annotation
% Called by the \annotationDefinition with different
% arguments depending on the definition
% Sets up several commands (shown for annotation 1):
%    \anoele 1      output the annotation name
%    \anonum1       output the annotation number
%    \anofignum 1   output the figure first shown in
\makeatletter
\def\@newannotation#1{
    \expandafter\ifx\csname anonum#1 \endcsname\relax
        \global\advance\@annotationnumber by 1
        \expandafter\edef\csname anoele \the\@annotationnumber\endcsname{#1}
        \expandafter\edef\csname anonum#1 \endcsname{\the\@annotationnumber}
        \expandafter\edef\csname anofignum \the\@annotationnumber\endcsname{%
            \the\@annotationfigurenumber}
    \else
        \message{error: duplicate annotation #1}
    \fi}
\makeatother

% Command to create a new annotation
% Modes: multi, single, full
\makeatletter
\def\annotationDefinition{%
    \@ifnextchar[{\@annotationDefinitionmulti}{\@newannotation}}
\def\@annotationDefinitionmulti[#1]#2{%
    \@newannotation{#2}\annotationName{#1}
    \@ifnextchar[{\@annotationDefinitionfull}{}}
\def\@annotationDefinitionfull[#1]{\annotationDescription{#1}}
\makeatother

% Separate command for setting the description for the most
% recently defined annotation
\makeatletter
\def\annotationDescription#1{%
    \expandafter\ifx\csname anodesc \the\@annotationnumber\endcsname\relax
        \expandafter\def\csname anodesc \the\@annotationnumber\endcsname{#1}
    \else
    \message{error while assigning description ``#1'' to annotation variable
        ``\annotationListVariableName{\the\@annotationnumber}''
         - it was already defined as
        ``\annotationListDescription{\the\@annotationnumber}''.}
    \fi}
\makeatother

% Separate command for setting the name for the most recently
% defined annotation
\makeatletter
\def\annotationName#1{%
    \expandafter\ifx\csname anotext \the\@annotationnumber\endcsname\relax
        \expandafter\def\csname anotext \the\@annotationnumber\endcsname{#1}
    \else
        \message{error while assigning text name ``#1'' to annotation variable
        ``\annotationListVariableName{\the\@annotationnumber}''
         - it was already defined as
        ``\annotationListText{\the\@annotationnumber}''.}
    \fi}
\makeatother

% Command to insert an annotation reference number only
% Uses \annotationNumberReference, which uses \anonum1
\makeatletter
\def\annotationReference#1{%
[\thinspace\annotationNumberReference{#1}\thinspace]}
\makeatother

% Command to insert the annotation's name and number
% Uses \annotationTextReference, which uses \anotext 1
\def\annotationNameAndReference#1{%
\annotationTextReference{#1}~\annotationReference{#1}}

% Command to insert the description of an annotation
% Uses the command \anodesc 1 where 1 is the annotation's
% number
\def\annotationDescriptionreference#1{%
\csname anodesc \annotationNumberReference{#1}\endcsname}

% Command to insert the name of an annotation
% Uses the command \anotext 1 where 1 is the annotation's
% number
\def\annotationTextReference#1{%
\csname anotext \annotationNumberReference{#1}\endcsname}

% Command to insert the number of an annotation
% Uses the command \anonum1, where 1 is the annotation's
% number
\def\annotationNumberReference#1{\csname anonum#1 \endcsname}

% Command to insert the number of an annotation, underlined
\def\annotationNumberReferenceUnderlined#1{\underline{\csname anonum#1 \endcsname}}

% Command to output the variable name of an annotation
\def\annotationListVariableName#1{\csname anoele #1\endcsname}

% Command to output the name of an annotation
\def\annotationListText#1{\csname anotext #1\endcsname}

% Command to output the description of an annotation
\def\annotationListDescription#1{\csname anodesc #1\endcsname}

% Command to output the number of the figure where an
% annotation is first referenced
\def\annotationListFigureNumber#1{\csname anofignum #1\endcsname}

% -----------------------
% Figure macro section
% -----------------------

% Command to output the description of a figure
\def\annotationListFigureDescription#1{\csname anofigdesc #1\endcsname}

% Command to output the file extension of a figure
\def\annotationListFigureExtension#1{\csname anofigext #1\endcsname}

% Command to output the caption of a figure
\def\annotationListFigureCaption#1{\csname anofigcap #1\endcsname}

% Command to output the name of a figure
\def\annotationListFigureName#1{\csname anofigname #1\endcsname}

% Command to output the orientation of a figure
\def\annotationListFigureOrientation#1{\csname anofigor #1\endcsname}

% Define an environment for the figures
\newenvironment{pfigure}{\begin{figure}}{\end{figure}}

% Set up page depending on the orientation specified
% for a figure
\def\figureStartWithOrientation#1{
    \expandafter\ifx\csname anofigor #1\endcsname\relax
        \renewenvironment{pfigure}{\begin{figure}[ht]}{\end{figure}}
    \else
        \renewenvironment{pfigure}{\begin{sidewaysfigure}}{\end{sidewaysfigure}}
    \fi}

% macro to decide whether or not to print a new
% figure heading
% The two arguments are the new figure number
% for the annotation currently being printed, and
% the existing figure number counter.
% Used in the BDOD section
\def\annotationListPrintFigure#1#2{
    \edef\testa{#1}
    \edef\testb{#2}
    \edef\testzero{0}
    % If the second argument (existing counter) is zero,
    % no headings have been printed yet, so print a heading
    \ifx\testb\testzero
        \figureName #1---\printable{\dwgDir}/%
        \printable{\annotationListFigureName{#1}}.%
        \printable{\annotationListFigureExtension{#1}}%
        ---\annotationListFigureDescription{#1}
        \par
    \else
        % If the second argument is not zero, but is equal to
        % the first argument, do nothing
        \ifx\testa\testb
        \else
            % If the second argument is not equal to the first,
            % output the figure heading (a new figure is being
            % output)
            \figureName #1---\printable{\dwgDir}/%
            \printable{\annotationListFigureName{#1}}.%
            \printable{\annotationListFigureExtension{#1}}%
            ---\annotationListFigureDescription{#1}
            \par
        \fi
    \fi}

% -----------------------
% Annotation list section
% -----------------------

% Section to print the annotation list
\def\annotationListSectionName{\section*{Annotation List}}

\makeatletter
\def\printAnnotationList{{%
    % Start the counters at 1 and 0
    \@annotationnumber=1
    \@annotationfigurenumber=0
    % If the macro for an annotation element exists,
    % then there are annotations to print, so output 
    % the section name
    \expandafter\ifx\csname anoele \the\@annotationnumber\endcsname\relax
    \else
        \annotationListSectionName\par

        % Loop to look through the possible annotation numbers
        % and output the annotation list
        \loop
            % The condition for the loop is that the anoele macro
            % with the current number exists. When the loop reaches
            % an anoele with a number that does not exist, it terminates
            \expandafter\ifx\csname anoele \the\@annotationnumber\endcsname\relax
            \else
                \leftskip = -10 pt
                % This macro determines if a new figure section
                % has started and outputs the figure number, path, and
                % description if so. First argument is the figure number
                % of the annotation currenly being output, second
                % argument is the current figure number.
                \annotationListPrintFigure{%
                    \annotationListFigureNumber{\the\@annotationnumber}}
                    {\the\@annotationfigurenumber}
                \leftskip = 10 pt
                %\hangindent = 20 pt
                %\hangafter
                \par
                % Set the counter to the figure corresponding to
                % the current annotation
                \@annotationfigurenumber=%
                    \annotationListFigureNumber{\the\@annotationnumber}
                % Output the annotation data: number, var name, text name, 
                % description
                \the\@annotationnumber---%
                \annotationListVariableName{\the\@annotationnumber}---%
                \annotationListText{\the\@annotationnumber}---%
                \annotationListDescription{\the\@annotationnumber}
                \par
                \leftskip = -10 pt
                % Increment the annotation counter and repeat the loop
                \advance\@annotationnumber by 1
                \repeat
    \fi}}
\makeatother

% Helper for outputting the figure description
\def\annotationFigureListPrintFigure#1{%
\figureName ~#1 \annotationListFigureDescription{#1}}

% ------------------------------------------------
% Brief Description of the Drawings Section (BDOD)
% ------------------------------------------------

% The following two macros are used later on to output a section
% heading if there is at least one drawing defined
\def\annotationFigureListSectionName{%
    \section*{Brief Description of the Drawings}}

\def\annotationFigureListPreamble{%
    For a more complete understanding of the invention,
    reference is made to the following description and accompanying
    drawings, in which:
    \par}

% Set figure list terminations when not using ;s
\def\setFigureListNoRunOn{%
    \def\annotationFigureListLast{.}
    \def\annotationFigureListNextLast{.}
    \def\annotationFigureListOther{.}}

% Set figure list terminations for ; style
\def\annotationFigureListLast{.}
\def\annotationFigureListNextLast{; and}
\def\annotationFigureListOther{;}

% macro to output the content for the "Brief
% Description of the Drawings"
\makeatletter
\def\printAnnotationFigureList{{
    % Start at figure 1
    \@annotationfigurenumber=1
    % Make sure at least one figure is described
    \expandafter\ifx\csname anofigdesc \the\@annotationfigurenumber\endcsname\relax
    \else
        % If at least one figure is described, output the
        % BDOD section and preamble
        \annotationFigureListSectionName\par
        \annotationFigureListPreamble\par
        % Loop through all the drawings
        \loop
            % Conditional for this loop is that the macro
            % anofigdisc 1 (where 1 is the figure number) exists
            \expandafter\ifx\csname anofigdesc \the\@annotationfigurenumber\endcsname\relax
            \else
                % Output the figure annotation
                \annotationFigureListPrintFigure{\the\@annotationfigurenumber}%
                % Next few lines figure out if the current figure
                % is last, next to last, or neither
                {\advance\@annotationfigurenumber by 1
                    % If the anofigdesc macro does not exist when
                    % increased by one, we are on the last figure
                    \expandafter\ifx\csname anofigdesc \the\@annotationfigurenumber\endcsname\relax
                        \annotationFigureListLast
                    \else{%
                        % Otherwise, check if we are on the next
                        % to last figure
                        \advance\@annotationfigurenumber by 1
                        % If the anofigdesc macro does not exist
                        % when increased by two, we are on the 
                        % next to last figure
                        \expandafter\ifx\csname anofigdesc \the\@annotationfigurenumber\endcsname\relax
                            \annotationFigureListNextLast
                        \else
                            % At this point, we are neither the
                            % last nor next to last, so output
                            % the standard line ending
                            \annotationFigureListOther
                            \par
                        \fi
                    }
                    \fi
                }
                \advance\@annotationfigurenumber by 1
        \repeat
    \fi}}
\makeatother

% -------------------------------
% Figure drawing macro section
% -------------------------------

% When defining a figure, create the anofigdesc macro to go
% with the figure number. If a second attempt is made before
% a new figure is defined, output an error.
\makeatletter
\def\figureDescription#1{%
    \expandafter\ifx\csname anofigdesc \the\@annotationfigurenumber\endcsname\relax
        \expandafter\def\csname anofigdesc \the\@annotationfigurenumber\endcsname{#1}
    \else
        \message{error while assigning description ``#1'' to annotation figure number
        ``\the\@annotationfigurenumber'' - it was already defined as
        ``\annotationListFigureDescription{\the\@annotationfigurenumber}''.}
    \fi}
\makeatother

% When defining a figure's extension, create the anofigext
% macro to go with the figure number. If a second attempt
% is made before a new figure is defined, output an error.
\makeatletter
\def\figureExtension#1{%
    \expandafter\ifx\csname anofigext \the\@annotationfigurenumber\endcsname\relax
        \expandafter\def\csname anofigext \the\@annotationfigurenumber\endcsname{#1}
    \else
        \message{error while assigning extension ``#1'' to annotation figure number
        ``\the\@annotationfigurenumber'' - it was already defined as
        ``\annotationListFigureExtension{\the\@annotationfigurenumber}''.}
    \fi}
\makeatother

% When defining a figure's caption, create the anofigcap
% macro to go with the figure number. If a second attempt
% is made before a new figure is defined, output an error.
\makeatletter
\def\figureCaption#1{%
    \expandafter\ifx\csname anofigcap \the\@annotationfigurenumber\endcsname\relax
        \expandafter\def\csname anofigcap \the\@annotationfigurenumber\endcsname{#1}
    \else
        \message{error while assigning caption ``#1'' to annotation figure number 
        ``\the\@annotationfigurenumber'' - it was already defined as
        ``\annotationListFigureCaption{\the\@annotationfigurenumber}''.}\fi}
\makeatother

% When defining a figure as sideways, create the anofigor
% macro to go with the figure number. If a second attempt
% is made before a new figure is defined, output an error.
\makeatletter
\def\figureOrientationSideways#1{%
    \expandafter\ifx\csname anofigor \the\@annotationfigurenumber\endcsname\relax
        \expandafter\def\csname anofigor \the\@annotationfigurenumber\endcsname{#1}
    \else
        \message{error while assigning orientation ``#1'' to annotation figure number 
        ``\the\@annotationfigurenumber'' - it was already defined as
        ``\annotationListFigureOrientation{\the\@annotationfigurenumber}''.}
    \fi}
\makeatother

% macro for clearing the page after a figure, used in 
% specific cases outlined in the documentation.
\makeatletter
\def\figureClearPageAfter{%
    \expandafter\def\csname anofigcp \the\@annotationfigurenumber\endcsname{}}
\makeatother

% Internal macro to handle creating a new figure definition
\makeatletter
\def\@newfigure#1{
    \expandafter\ifx\csname fignum#1 \endcsname\relax
        % If the fignumx (where x is the figure number) macro
        % is not yet defined, define it and the anofigname macros
        \global\advance\@annotationfigurenumber by 1
        \expandafter\edef\csname anofigname \the\@annotationfigurenumber\endcsname{#1}
        \expandafter\edef\csname fignum#1 \endcsname{\the\@annotationfigurenumber}
    \else
        % If the figure number has already been used, print an error
        \message{error: duplicate annotation #1}
    \fi}
\makeatother

% macros for allowing multi-argument definitions with
% the figure number and description, or just the
% figure number
\makeatletter
\def\figureDefinition{
    % If the next character is a [, use the multi version;
    % if not, just use the @newfigure funciton
    \@ifnextchar[{\@figuredefinitionmulti}{\@newfigure}}

% macro for defining the figure number
% and description in one go
\def\@figuredefinitionmulti[#1]#2{
    \@newfigure{#2}
    \figureDescription{#1}}
\makeatother

% -------------------------------
% Figure helper macros section
% -------------------------------

% Print the text "FIG." plus the figure number
\makeatletter
\def\figureReference#1{FIG.~\figurenumberreference{#1}}
\makeatother

% The current drawing directory
\newcommand{\dwgDir}{.}

% Print the number of a figure
\def\figurenumberreference#1{\csname fignum#1 \endcsname}

% macros for showing a figure that is a VBS listing
\expandafter\def\csname showfigure vbs\endcsname #1#2{%
    \lstinputlisting[language=VBScript]{\dwgDir/#1.#2}}

\expandafter\def\csname showfigure VBS\endcsname #1#2{%
    \lstinputlisting[language=VBScript]{\dwgDir/#1.#2}}

% macro for showing a figure that is a Python listing
\expandafter\def\csname showfigure py\endcsname #1#2{%
    \lstinputlisting[language=Python]{\dwgDir/#1.#2}}

% macros for showing a figure that is a text file
\expandafter\def\csname showfigure txt\endcsname #1#2{%
    \lstinputlisting[language={}]{\dwgDir/#1.#2}}

\expandafter\def\csname showfigure TXT\endcsname #1#2{%
    \lstinputlisting[language={}]{\dwgDir/#1.#2}}

% macros for showing a pdf file
\expandafter\def\csname showfigure pdf\endcsname #1#2{
    \includegraphics[]{#1.#2}}

\expandafter\def\csname showfigure PDF\endcsname #1#2{
    \includegraphics[]{#1.#2}}

% macros for showing a TPX file
\expandafter\def\csname showfigure tpx\endcsname #1#2{
    \input{"\dwgDir/#1.#2"}}

\expandafter\def\csname showfigure TpX\endcsname #1#2{
    \input{"\dwgDir/#1.#2"}}

% macros for showing tex / pdf_tex files
\expandafter\def\csname showfigure tex\endcsname #1#2{
    \input{"\dwgDir/#1.tex"}}

\expandafter\def\csname showfigure pdf_tex\endcsname #1#2{
    \input{"\dwgDir/#1.#2"}}

% macro for a figure placeholder
\expandafter\def\csname showfigure placeholder\endcsname #1#2{%
    no extension provided for file name \printable{#1}.\par This will be used as a placeholder}

% macro for an unknown file type
\expandafter\def\csname showfigure unk\endcsname #1#2{%
    \includegraphics[]{#1.#2}}

% ---------------------
% Figure output section
% ---------------------

\makeatletter
\def\figures{{%
    % Start with figure 1
    \@annotationfigurenumber=1
    % If the anofigname 1 macro is defined, at least one figure exists
    \expandafter\ifx\csname anofigname \the\@annotationfigurenumber\endcsname\relax
    \else
        % Output the headers etc.
        \figuresStart
        % Loop through figure numbers
        \loop
            % Keep looping as long as the anofigname x (where x is the current
            % counter number) is defined
            \expandafter\ifx\csname anofigname \the\@annotationfigurenumber\endcsname\relax
            \else
                % If an extension is not defined, define it as a placeholder
                \expandafter\ifx\csname anofigext \the\@annotationfigurenumber\endcsname\relax
                    \edef\figureextension{placeholder}
                % Otherwise, use the defined extension
                \else
                    \edef\figureextension{%
                        \annotationListFigureExtension{\the\@annotationfigurenumber}}
                \fi
                % Try using the helper macro that corresponds with
                % the defined figure extension
                \expandafter\ifx\csname showfigure \figureextension\endcsname\relax
                    % this is an unknown figure extension
                    \def\figureshower{\csname showfigure unk\endcsname}
                \else
                    % Use the helper macro for the defined
                    % figure extension
                    \def\figureshower{\csname showfigure \figureextension\endcsname}
                \fi
                \def\figurename{\annotationListFigureName{\the\@annotationfigurenumber}}
                \def\figurecaption{\annotationListFigureCaption{\the\@annotationfigurenumber}}
                % Set up the page for this figure's orientation
                \figureStartWithOrientation{\the\@annotationfigurenumber}
                \begin{pfigure}
                % Place figure captions in the appropriate place
                \ifFigureCaptionsOnTop
                    \centering\figureReference{\figurename}~~\figurecaption\par%
                    \figureshower{\figurename}{\figureextension}\par
                \else
                    \centering\figureshower{\figurename}{\figureextension}\par%
                    \figureReference{\figurename}~~\figurecaption\par
                \fi
                \end{pfigure}
                % Clear the page if defined for this figure
                \expandafter\ifx\csname anofigcp \the\@annotationfigurenumber\endcsname\relax
                \else
                    \clearpage
            \fi
            \advance\@annotationfigurenumber by 1
            \repeat
        \figuresEnd
    \fi}}
\makeatother

% -----------------------
% Miscellaneous macros
% -----------------------

% Helper for the title of the BDOD section
\def\annotationFigureListSectionName{
    \patentSection{Brief Description of the Drawings}}

% Helper for the title of the annotation list
\def\annotationListSectionName{
    \patentSection{Annotation List}}

% Helper macro for the preamble of the BDOD
\def\annotationFigureListPreamble{
    \patentParagraph{For a more complete understanding of the invention, reference is made to the following
        description and accompanying drawings, in which:}}

% Helper funciton for outputting the BDOD
\def\patentDrawingDescriptions{
    \printAnnotationFigureList}

% Helper for referencing a figure
\def\referencePatentFigure#1{\figureReference{#1}}

% Helper for referencing an annotation
\def\annotate#1{\annotationReference{#1}}

% Helper for referencing an annotation by name and number
\def\annotateWithName#1{\annotationNameAndReference{#1}}

% Helper for printing out a figure reference
% Used in the BDOD section
\def\annotationFigureListPrintFigure#1{%
\patentParagraph{\figureName ~#1 \annotationListFigureDescription{#1}}}

% Helper for a bare annotation number
\def\annotateNoBrackets#1{\annotationNumberReference{#1}}

% Helpers for starting and ending the patent drawings sections
\def\figuresStart{
    \patentDrawingsStart}

\def\figuresEnd{
    \patentDrawingsEnd}

% Print the annotation list if in draft mode, then
% print the figures
\def\patentDrawings{%
    \ifPatentOfficeMode
    \else
        \printAnnotationList
    \fi

    \figures}
\endinput
%%
%% End of file `uspatent.cls'.
