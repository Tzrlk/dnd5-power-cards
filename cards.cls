% http://tex.stackexchange.com/a/185830/113470

\ProvidesClass{cards}

\usepackage[dvipsnames]{xcolor}

\LoadClass[a4paper,landscape]{article}

\usepackage[utf8]{inputenc}
\usepackage[margin=5mm,top=8mm]{geometry}
\usepackage{graphicx}
\usepackage[english]{babel}

\usepackage{tikz}
\usetikzlibrary{patterns}
\usetikzlibrary{shadows}

% Font of text used on the cards
\usepackage{anttor}

% optical alignment
\usepackage{microtype}

% Symbols to load; Use \ding{<number>}
\usepackage{pifont}

% Other icons
\usepackage{fourier-orns}

% COLORS OF THE ELEMENTS / COMPONENTS OF CARDS
% -----------------------------------------

% Background color for the Title Case
\definecolor{titlebg}{RGB}{30,30,30}

% Colors of "flags" to identify the different types of cards
\definecolor{characterbg}{RGB}{0,100,200}
\definecolor{abilitybg}{RGB}{80,180,0}
\definecolor{itembg}{RGB}{200,50,50}
\definecolor{testbg}{RGB}{180,50,150}

% Color the "pennant" to indicate the price of the cards
\definecolor{pricebg}{RGB}{230,180,0}

% Background color for the text area
%\definecolor{content}{RGB}{250,250,245}
\definecolor{contentbg}{RGB}{255,255,255}

\def\cardwidth{6}

\pgfmathsetmacro{\cardheight}{9}
\pgfmathsetmacro{\imagewidth}{\cardwidth}
\pgfmathsetmacro{\imageheight}{0.75*\cardheight}
\pgfmathsetmacro{\stripwidth}{0.7}
\pgfmathsetmacro{\strippadding}{0.2}
\pgfmathsetmacro{\textpadding}{0.1}
\pgfmathsetmacro{\titley}{\cardheight-\strippadding-1.5*\textpadding-0.5*\stripwidth}


% Forms of individual map elements / Acquainted
\def\shapeCard{(0,0) rectangle (\cardwidth,\cardheight)}
\def\shapeLeftStripLong{(\strippadding,-0.2) rectangle (\strippadding+\stripwidth,\cardheight-\strippadding-\strippadding-1)}
\def\shapeLeftStripShort{(\strippadding,\cardheight-\strippadding-1) rectangle (\strippadding+\stripwidth,\cardheight+0.2)}
\def\shapeRightStripShort{(\cardwidth-\stripwidth-\strippadding,\cardheight-\strippadding-1) rectangle (\cardwidth-\strippadding,\cardheight+0.2)}
\def\shapeTitleArea{(2*\strippadding+\stripwidth,\cardheight-\strippadding) rectangle (\cardwidth-2*\strippadding-\stripwidth,\cardheight-2*\stripwidth)}
\def\shapeContentArea{(2*\strippadding+\stripwidth,0.5*\cardheight) rectangle (\cardwidth+0.2,-0.2)}

% define styles for the elements
\tikzset{
	% rounded corners for cards
	cardcorners/.style={
		rounded corners=0.2cm
	},
	% rounded corners for "pennant"
	elementcorners/.style={
		rounded corners=0.1cm
	},
	% Shadow for "pennant"
	stripshadow/.style={
		drop shadow={
			opacity=.5,
			color=black
		}
	},
	% Style for the "flags"
	strip/.style={
		elementcorners,
		stripshadow
	},
	% Image for the card motif
	cardimage/.style={
		path picture={
			\node[below=-1.5mm] at (0.5*\cardwidth,\cardheight) {
				\includegraphics[width=\imagewidth cm]{#1}
			};
		}
	},
}

%   TikZ-Raster
\newcommand{\carddebug}{
	\draw [step=1,help lines] (0,0) grid (\cardwidth,\cardheight);
}

% Setting the map
\newcommand{\cardborder}{
	\draw[lightgray,cardcorners] \shapeCard;
}

% Background map
\newcommand{\cardbackground}[1]{
	\draw[cardcorners, cardimage=#1] \shapeCard;
}

% Category map
\newcommand{\cardtype}[3]{

	%   First we fill the intersecting area
	%   The \clip command does not allow options, therefore 
	%   we have to use a scope to set the even odd rule.
	\begin{scope}[even odd rule]

		%   Define a clipping path. All paths outside shapeCard will
		%   be cut because the even odd rule is set.
		\clip[cardcorners] \shapeCard;

		% Fill shapeLeftStripLong and shapeLeftStripShort.
		%   Since the even odd rule is set, only the card will be filled.
		\fill[strip,#1] \shapeLeftStripLong node[rotate=90,above left=0.9mm,font=\normalsize] {
			\color{white}\uppercase{#2}
		};
		\fill[strip,#1] \shapeLeftStripShort;

	\end{scope}

	\node at (\strippadding+\stripwidth-0.28,\cardheight-\strippadding-\strippadding-0.37) {\color{white}#3};
}
\newcommand{\cardtypePerLongRest}{\cardtype{characterbg}{Once Per Long Rest}{\hspace{-1mm}\LARGE\lefthand}}
\newcommand{\cardtypePerTurn}{\cardtype{abilitybg}{Once Per Turn}{\hspace{-1mm}\Large\floweroneright}}
\newcommand{\cardtypePerRest}{\cardtype{itembg}{Once Per Rest}{\hspace{-1mm}\LARGE\bomb}}
\newcommand{\cardtypeAtWill}{\cardtype{testbg}{At-will}{\hspace{-1.4mm}\huge\ding{78}}}

% Title Card
\newcommand{\cardtitle}[1]{
	%\draw[pattern=soft crosshatch,rounded corners=0.1cm] \shapeTitleArea;
	\fill[elementcorners,titlebg,opacity=.85] \shapeTitleArea;
	\node[text width=3.75cm] at (0.5*\cardwidth,\titley) {
		\begin{center}
			\color{white}\uppercase{\normalsize #1}
		\end{center}
	};
}

% Content map
\newcommand{\cardcontent}[2]{
	\begin{scope}[even odd rule]
		\clip[cardcorners] \shapeCard;
		\fill[elementcorners,contentbg] \shapeContentArea;
	\end{scope}
	\node[below right, text width=(\cardwidth-2*\strippadding-\stripwidth-2*\textpadding-0.3)*1cm] at (2*\strippadding+\stripwidth+\textpadding,7) {
		{\scriptsize #1}		
		\vrule width \textwidth height 2pt \\[-2pt]
		\vspace{0.2cm}
		{\scriptsize #2}
	};
}

% Price Map
\newcommand{\cardprice}[1]{
	\begin{scope}[even odd rule]
		\clip[cardcorners] \shapeCard;
		\fill[strip,pricebg] \shapeRightStripShort;
	\end{scope}
	\node at (\cardwidth-0.5*\stripwidth-\strippadding,\titley-0.1) {#1};
}

\newcommand{\hpad}{\hspace{10mm}}
\newcommand{\vpad}{\vspace{10mm}}
