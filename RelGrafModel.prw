#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#Include "ParmType.ch"
#include "CXInclude.ch"
#INCLUDE "CXMSPrinter.ch"
#Include "ParmType.ch"

/////////////testar sem nHM e nVM usando apenas as margens padrao (spool e pdf)

//#############################################################################
//##+==========+==========+=======+====================+======+=============+##
//##|Programa  | RelModel | Autor |                    | Data |   /  /      |##
//##+==========+==========+=======+====================+======+=============+##
//##|Descricao | Modelo de referencia para relatorios graficos              |##
//##|          |                                                            |##
//##|          |                                                            |##
//##|          |                                                            |##
//##+==========+===============+============================================+##
//##|   DATA   | Programador   | Manutencao Efetuada                        |##
//##+==========+===============+============================================+##
//##|          |               |                                            |##
//##|          |               |                                            |##
//##|          |               |                                            |##
//##+==========+===============+============================================+##
//#############################################################################

//Espessura de linhas no PDF
Static cEspLin			:= '-8'

//-------------------------------------------------------------------------------------------------
User Function RelModel()
	
	//Declaracao de variaveis----------------------------------------------------------------------
//	Local aPerg					AS Array
	Local bImprime				AS CodeBlock
	Local lRet		:= .T.		AS Logical
	Local nOrdem	:= 0		AS Numeric

	//+---------------------------+
	//| Variaveis de configuracao |
	//+---------------------------+
	//Versao 3.00 2023-01-08
	Local oCfgRel				AS Object // Objeto para configuracao de relatorios

	//---------------------------------------------------------------------------------------------

	//COLOQUE AQUI AS VALIDACOES E PRE-PROCESSAMENTOS
	
	//---------------------------------------------------------------------------------------------

	//Inicializa Variaveis-------------------------------------------------------------------------
//	aPerg				:= { {"Num. Vias (x2)?" , "N", 1,  0,"Positivo() .And. NaoVazio()"} }

	//---------------------------------------------------------------------------------------------

	oCfgRel	:=	tCXRelGraf():New() //Cria objeto de configuracao
	
	oCfgRel:cNomeProg		:= 'CXTESTE'					// Nome do fonte do relatorio
	oCfgRel:cTitulo			:= 'Relatório de Teste'			// Titulo do relatorio para impressao
//	oCfgRel:cPerg			:= oCfgRel:cNomeProg			// cPerg se for utilizado
//	oCfgRel:aPerg			:= aPerg						// Dados das perguntas
//	oCfgRel:bPerg			:= bPerg						// Bloco de codigo para o botao parametros
//	oCfgRel:aOrder			:= aOrdem						// Array com as ordens de impressao do relatorio
//	oCfgRel:nOrder			:= nOrdem						// Variavel que define a ordem de impressao
//	oCfgRel:lInJob			:= .T.					  		// Indica se a impressao e' vai JOB (NO SERVIDOR)
//	oCfgRel:lAdjustToLegacy	:= .T. 							// Ajuste para utilizar as mesmas coordenadas da classe TMSPrinter (COMPATIBILIDADE) (Def .F.)
//	oCfgRel:_lBoxLegacy		:= .T.							// Define se os Box serao impressos pelo modo antigo, com fundo branco

//	oCfgRel:lRaw			:= .T.							// Enviar para a dispositivo de impressao caracteres binários(RAW)
//	oCfgRel:lTReport		:= .T.							// Indica que a classe foi chamada pelo TReport.
//	oCfgRel:lPDFAsPNG		:= .T.							// Indica que será gerado o PDF no formato PNG
//	oCfgRel:lDisabeSetup	:= .T.							// Inibe a tela de setup na abertua do objeto (Def .F.)
//	oCfgRel:cDirPrint		:= FwSuperGetMV('MV_RELT')		// Diretorio de impressao temporario (OPCIONAL)

//---Parametros para impressao em PDF NAO PRECISA SETAR OS PARAMETROS DE TIPO DE IMPRESSAO E DESTINACAO
//	oCfgRel:cArqRel			:= Upper(oCfgRel:cNomeProg)+'_'+DtoS(Date())+'_'+StrTran(Time(),':','') (OPCIONAL)
//	oCfgRel:cPathDest		:= cPathDest
//	oCfgRel:lPreview		:= .F.							// Desabilita o preview do PDF

	//+------------------------------+
	//| Flags do objeto FWPrintSetup |
	//+------------------------------+
//	oCfgRel:lIsTotvsPrinter	:= .F. // (Def .T.)(OPCIONAL)
//	oCfgRel:lDsOrientation	:= .F. // (Def .T.)(OPCIONAL)
//	oCfgRel:lDsPaperSize	:= .F. // (Def .T.)(OPCIONAL)
//	oCfgRel:lDsMargin		:= .F. // (Def .T.)(OPCIONAL)
//	oCfgRel:lDsDestination	:= .F. // (Def .T.)(OPCIONAL)

//	oCfgRel:cDevice			:= "SPOOL" 			// (OPCIONAL)
//	oCfgRel:nPrintType		:= IMP_SPOOL		// (OPCIONAL) //Informar este ou o acima
//	oCfgRel:nDestination	:= AMB_CLIENT		// (OPCIONAL)
//	oCfgRel:nOrientation	:= nPD_RETRATO		// (OPCIONAL)
//	oCfgRel:nPaperSize		:= U_CXConvPSize(DMPAPER_A4,'F') //Converte de FWMsPrinter p/ TMSPrinter // (OPCIONAL)
//	oCfgRel:aMargens		:= {00,00,00,00}

	lRet	:= oCfgRel:Inicializa() //Inicializa objeto
		
	If lRet
		//	nOrdem	:= oCfgRel:nOrder
		bImprime	:= {|| lRet	:= ImpRel(nOrdem) }
		If oCfgRel:lInJob
			Eval(bImprime)
		Else
			FWMsgRun(/*oSay*/,bImprime,U_CXTxtMsg()+'Imprimindo '+oCfgRel:cTitulo,'Aguarde...')
		EndIf
	EndIf

	//Destroi os objetos tCXRelGraf,CXPrintSetup,CXMSPrinter e tCXRelGraf
	oCfgRel:Destroy()
	FwFreeVar(oCfgRel)
	
Return lRet

//-------------------------------------------------------------------------------------------------
// FUNÇÃO PARA IMPRESSÃO DO RELATÓRIO
//-------------------------------------------------------------------------------------------------
Static Function ImpRel(nOrdem);	//01 nOrdem
							AS Logical

	//Declaracao de variaveis----------------------------------------------------------------------
	//Local cAssBmp			AS Character
	Local oArea				AS Object

	Local aObs				AS Array

	//+--------------------------------------------+
	//| Cria fontes para serem usadas na impressao |
	//+--------------------------------------------+
	//                          fonte  tm    N      S   I
	Private oFonte06	:= tFont():New("Arial",,06,,.F.,,,,.F.,.F.)		AS Object
	Private oFonte06N	:= tFont():New("Arial",,06,,.T.,,,,.F.,.F.)		AS Object

	Private oFonte08	:= tFont():New("Arial",,08,,.F.,,,,.F.,.F.)		AS Object
	Private oFonte08N	:= tFont():New("Arial",,08,,.T.,,,,.F.,.F.)		AS Object

	Private oFonte10	:= tFont():New("Arial",,10,,.F.,,,,.F.,.F.)		AS Object
	Private oFonte10N	:= tFont():New("Arial",,10,,.T.,,,,.F.,.F.)		AS Object

	Private oFonte11	:= tFont():New("Arial",,11,,.F.,,,,.F.,.F.)		AS Object
	Private oFonte11N	:= tFont():New("Arial",,11,,.T.,,,,.F.,.F.)		AS Object

	Private oFonte12	:= tFont():New("Arial",,12,,.F.,,,,.F.,.F.)		AS Object
	Private oFonte12N	:= tFont():New("Arial",,12,,.T.,,,,.F.,.F.)		AS Object

	Private oFonte14	:= tFont():New("Arial",,14,,.F.,,,,.F.,.F.)		AS Object
	Private oFonte14N	:= tFont():New("Arial",,14,,.T.,,,,.F.,.F.)		AS Object

	Private oFonte20	:= tFont():New("Arial",,20,,.F.,,,,.F.,.F.)		AS Object
	Private oFonte20N	:= tFont():New("Arial",,20,,.T.,,,,.F.,.F.)		AS Object

	//Inicializa Variaveis-------------------------------------------------------------------------
	oArea	:= tCtrlAlias():GetArea({'SA1','SA2'})	// ALIAS A SEREM SALVOS A AREA

	//-----------------------------------------------------------------------------
	
	//COLOQUE AQUI AS VARIAVEIS MV_PAR??
	// nVias := MV_PAR01 //por exemplo
	
	//-----------------------------------------------------------------------------

	//#####################################################################
	//#     VARIAVEIS DE POSICIONAMENTO DA PAGINA (MARGENS, TAMANHOS)     #
	//#####################################################################
	//#                                                                   #
	//# VARIAVEL PARA CONTROLE DE LINHAS                                  #
	//# nLin = Posicao da linha para impressao                            #
	//# nIncLin = Distancia entre linhas                                  #
	//#                                                                   #
	//# TAMANHOS DA PAGINA                                                #
	//# nHP	= Tamanho horizontal da pagina (sem margens)                  #
	//# nVP	= Tamanho vertical da pagina (sem margens)                    #
	//#                                                                   #
	//# MARGENS DA PAGINA                                                 #
	//# nHM = Margem horizontal da pagina                                 #
	//# nVM = Margem vertical da pagina                                   #
	//#                                                                   #
	//# nFH = Final horizontal 	(nHP-nHM)                                 #
	//# nFV = Final vertical	(nVP-nVM)                    	          #
	//#                                                                   #
	//# nLP = Largura disponivel para impressao	(nFH-nHM) ou (nHP-2*nHM)  #
	//# nAP = Altura  disponivel para impressao	(nFV-nVM) ou (nVP-2*nVM)  #
	//#                                                                   #
	//#####################################################################

	//-----------------------------------------------------------------------------

	//+----------------------+
	//| Inicializa variaveis |
	//+----------------------+
//	oRpt:nHM	:= 100		//Margens da pagina
//	oRpt:nVM	:= 050
	
//	oRpt:CXAreaImp() //Atualizadas dimensoes da impressao

	//Seta a altura entre linhas
	nIncLin	:= oRpt:CXTamLin(oFonte12,1.2)

	//-----------------------------------------------------------------------------

	//+-------------------------------------------------+-+
	//| Ja existe um cabecalho e rodape grafico padrao se |
	//| nao quiser customizar, se for customizar alimentar|
	//| esses dois atributos                              |
	//+-------------------------------------------------+-+
//	oRpt:bCabec		:= {|nLin,oRpt| CabecGrf() }	//{|nLin,oRpt| nVM  } //para sem cabeçalho
//	oRpt:bRodape	:= {|nLin| RodapeGrf() }		//{|nLin| nFV }	//para sem cabeçalho
//	oRpt:bQuebraPg	:= {|nLin,lImpRodape,nEspaco,lForca| QuebraPag(nLin,lImpRodape,nEspaco,lForca) }
	
	//-----------------------------------------------------------------------------
	
	//COLOQUE AQUI A QUERY OU ALGUM PRE-PROCESSAMENTO NECESSARIO

	//-----------------------------------------------------------------------------
	
	//+--------------------+
	//| Inicio da impressao|
	//+--------------------+

	//Inicia nova pagina
	nLin	:= Eval(oRpt:bQuebraPg,nLin)

	//-----------------------------------------------------------------------------

	//COLOQUE AQUI A IMPRESSAO DO SEU RELATORIO
	
	cTextoExemplo	:=	"	Lorem ipsum dolor sit amet. Est rerum perspiciatis aut iste vero quo velit "+;
						"corrupti cum omnis atque et facilis aspernatur et consequatur quos et quia "+;
						"reprehenderit. A nesciunt minus qui expedita modi sed repudiandae exercitationem. "+;
						"Ad dolores dolor ut dolorem culpa quo quia eligendi nam quidem sint ut consequuntur "+;
						"voluptatum ut assumenda voluptas et minima provident. Et asperiores nobis non nesciunt"+;
						"quae est nobis galisum non fuga repellendus ut cupiditate corrupti ut officiis nulla."+CRLF+;
						"	Ea alias velit nam voluptatem omnis ea aliquam laborum qui sint magni ut sint atque. "+;
						"Aut repellat voluptatum At error consequatur vel fugiat possimus est sunt nulla. Et "+;
						"reiciendis omnis qui libero ipsam qui galisum incidunt sit culpa sint et suscipit aliquid."

	nLin	+= nIncLin

	//       linha coluna   texto      fonte      tamanho para impressao
	oRpt:SayC(nLin ,  nHM, "EXEMPLO" , oFonte20N, nLP )				//Impressao centralizada
	nLin	+= nIncLin * 2											//Incrementa a linha

	//Quebra de pagina
	nLin	:= Eval(oRpt:bQuebraPg,nLin,,3*nIncLin)

	//       linha  coluna final           texto     fonte
	oRpt:SayR(nLin , nFH, U_CXDataExtenso(Date()) , oFonte14 )		//Impressao alinhada a direita
	nLin	+= nIncLin * 2                                       	//Incrementa a linha

	//Quebra de pagina
	nLin	:= Eval(oRpt:bQuebraPg,nLin,,3*nIncLin)

	oRpt:Say (nLin , nHM	   , "TEXTO EXEMPLO",oFonte08N)
	nLin	+= nIncLin * 2

	//+-------------------------------------------------------------+
	//| Array para impressao do pedido de vendas.                   |
	//| Estrutura:                                                  |
	//|            [1] - Titulo do box                              |
	//|            [2] - Array com campos para impressao            |
	//|                   [2][1] - Primeira coluna                  |
	//|                         [2][1][1] - Titulo do campo         |
	//|                         [2][1][2] - Conteudo para impressao |
	//|                   [2][...] - outras colunas se houver       |
	//|            [...]                                            |
	//+-------------------------------------------------------------+
	aImp	:= {}
	nTab	:= 70

	aAdd(aImp,{"DADOS DO CLIENTE"} )
	aTemp	:= {}
	aAdd(aTemp,{"CLIENTE"	,SA1->A1_COD+'-'+SA1->A1_LOJA+' - '+RTrim(SA1->A1_NOME) })
	aAdd(aTemp,{{"ENDEREÇO"	,SA1->A1_END }	,;
				{"BAIRRO"	,SA1->A1_BAIRRO}})
	aAdd(aTemp,{{"CIDADE",RTrim(SA1->A1_MUN)+ ' / ' + SA1->A1_EST} 	,;
				{"C.E.P.",transform(SA1->A1_CEP,"@R 99.999-999")} 	})
	aAdd(aTail(aImp),aTemp)

	aAdd(aImp,{"ENDEREÇO DE ENTREGA"} )
	aTemp	:= {}
	aAdd(aTemp,{{"ENDEREÇO"	,'RUA DE TESTE' }	,;
				{"BAIRRO"	,'CENTRO' }	})
	aAdd(aTemp,{{"CIDADE",'FORTALEZA / CE'} 	,;
				{"C.E.P.",Transform('59619250',"@R 99.999-999")} 	})
	aAdd(aTail(aImp),aTemp)

	//Imprime informacoes
	nLin	:= oRpt:CXBoxTxt(aImp,nVM,nHM,nLin,oFonte12N,oFonte12,nTab,1)
	
	aImp	:= {}
	nTab	:= 90
	nLin	+= nIncLin/2
	
	//+-------------------------------------------------------------+
	//| Array para impressao do pedido de vendas.                   |
	//| Estrutura:                                                  |
	//|            [1] - Titulo do box                              |
	//|            [2] - Array com cabecalho                        |
	//|                [2][1] - Primeira coluna                     |
	//|                   [2][1][1] - Titulo da coluna              |
	//|                   [2][1][2] - Tamanho da coluna			    |
	//|            [3] - Array com campos para impressao            |
	//|                   [3][1] - Primeira coluna                  |
	//|            [...]                                            |
	//+-------------------------------------------------------------+
	
	aProds	:= {}
	aTemp	:= {}
	aAdd(aProds,"PRODUTOS")
	aAdd(aProds,{	{"IT"       ,025,'E'},;
					{"CODIGO"   ,035,'E'},;
					{"DESCRICAO",170,'E'},;
					{"GRP"		,030,'E'},;
					{"CC"       ,030,'E'},;
					{"UM"  		,020,'E'},;
					{"SALDO"	,034,'E'},;	  		//campo adicionado
					{"COMPRA" 	,042,'E'},;
					{"ULT_COM"	,050,'E'},;
					{"ULT_FOR"	,060,'E'},;
					{"ULT_PRC"	,040,'E'}})

	SB1->(U_CXSetOrd(1))
	SC1->(U_CXSetOrd(1))
	SC1->(dbGoTop())
	cFilSC	:= SC1->C1_FILIAL
	cNumSC	:= SC1->C1_NUM
	While SC1->(!EOF()) .And. ;
		SC1->C1_FILIAL == cFilSC .And. ;
		SC1->C1_NUM == cNumSC
		
		SB1->(MsSeek(xFilial('SB1')+SC1->C1_PRODUTO))

		aAdd(aTemp,array(11))
		aTail(aTemp)[01]	:= SC1->C1_ITEM
		aTail(aTemp)[02]	:= SC1->C1_PRODUTO
		aTail(aTemp)[03]	:= SB1->B1_DESC
		aTail(aTemp)[04]	:= SB1->B1_GRUPO
		aTail(aTemp)[05]	:= SC1->C1_CC
		aTail(aTemp)[06]	:= SB1->B1_UM
		aTail(aTemp)[07]	:= Transform(123.11,"@E 99999.99")
		aTail(aTemp)[08]	:= Transform(SC1->C1_QUANT  ,"@E 99999.99")
		aTail(aTemp)[09]	:= '01/01/23'
		aTail(aTemp)[10]	:= 'fornecedor'
		aTail(aTemp)[11]	:= Transform(14546, '@E 99,999.99')
		
		SC1->(dbSkip())
	EndDo
	
	aAdd(aProds,aTemp)
	
	//Imprime informacoes
	nLin	:= oRpt:CXBoxItens(aProds,nVM,nHM,nLin,oFonte12N,oFonte08,1.25)

	aObs	:= {}
	aAdd(aObs,{'I M P O R T A N T E'} )
	aAdd(aTail(aObs),{	'O PAGAMENTO SÓ SERÁ REALIZADO MEDIANTE CONFERÊNCIA DE CPF, IDENTIDADE, '+;
						'DOCUMENTO DO VEÍCULO E NOTAS FISCAIS MENCIONADAS NESTE RECIBO.'		})
	nLin	:= oRpt:CXBoxTxt(aObs,nVM,nHM,nLin,oFonte12N,oFonte12N,nTab,0.90,,,60)
	
	//Quebra de pagina
	//nLin	:= Eval(oRpt:bQuebraPg,nLin,,3*nIncLin)

	//Usuario responsavel pelo pos vendas
	//cAssBmp	:= U_CXGetAss(/*cCodUsr*/,/*lVazia*/)
	//If .Not. Empty(cAssBmp)
	// 	oRpt:SayBitmap(nLin,nHM+0010,cAssBmp,0150,0080)
	//EndIf

	nLin	+= 2*nIncLin

	//Quebra de pagina
	nLin	:= Eval(oRpt:bQuebraPg,nLin,,3*nIncLin)

	//       linha coluna     texto       fonte   tamanho EpsLinh   Final pagina
	nLin	:= oRpt:SayJ(nLin ,  nHM,cTextoExemplo,@oFonte12,nLP,nIncLin  ,nVP) //Impressao justificada

	//-----------------------------------------------------------------------------
	
	//+------------------------------------------------------------------------+
	//| TERMINO ROTINA DE IMPRESSAO                                            |
	//+------------------------------------------------------------------------+

	//Imprime o rodape da ultima pagina
	nLin	:= Eval(oRpt:bQuebraPg,nLin,.T.)

	//+------------------------------------------------------------------------+
	//| Usando assim serao impressas assinaturas na ultima pagina do relatorio |
	//| Fica a possibilidade futura de alterar o CXQuebraPg para imprimir as   |
	//| assinaturas em todas as paginas.                                       |
	//+------------------------------------------------------------------------+
	//	Eval(oRpt:bRodape,nLin,aAssina) //Imprime o rodape
	
	oRpt:Print()
	
	oArea:RestArea()		//Restaura area
	oArea:Destroy()
	FWFreeVar(oArea)

Return .T.

//-------------------------------------------------------------------------------------------------
// Impressao do cabecalho do relatorio em PDF
//-------------------------------------------------------------------------------------------------

//O CABECALHO E RODAPE ABAIXO SAO APENAS MODELOS CASO O USUARIO QUEIRA MODIFICAR O QUE JA EXISTE NA CLASSE CXMSPRINTER
/*
Static Function CabecGrf(nLin)
	
	//Declaracao de variaveis----------------------------------------------------------------------
	Local cLogo   			AS Character
	Local cNomeEmp			AS Character
	Local nIncLin			AS Numeric
	Local nTab1,nTab2		AS Numeric

	//Parametros da rotina-------------------------------------------------------------------------
	ParamType 0		VAR nLin  	  		AS Numeric		Optional Default nVM

	//Inicializa Variaveis-------------------------------------------------------------------------
	cLogo   		:= U_CXLogo()
	cNomeEmp		:= FWSM0Util():getSM0FullName() //SuperGetMV('MS_NOMEMP',.F.,SM0->M0_NOMECOM)
	nIncLin			:= oRpt:CXTamLin(oFonte12,1)
	nTab1			:= oRpt:ConvH(380)
	nTab2			:= oRpt:ConvH(180)
	
	//Erro padrao quando pdf a margem superior comeca em 20
	If (oRpt:nDevice == IMP_PDF)
		nLin	-= oRpt:nMS //Ajusta a posicao inicial
	EndIf

	//-------------------------------------------------------------------------------------------------

	//+----------------------------------+
	//| Inicio da impressao do cabecalho |
	//+----------------------------------+

	//Imprime logomarca
	oRpt:SayBitmap( nLin + nIncLin/5, nHM, cLogo, 3 * nIncLin , 3 * nIncLin )
	
	//*********//*******************************************************************
	//  LOGO   //         CIMSAL COM E IND DE M E REF STA CECILIA  Pagina.:      001
	//   DA    //                                                  Emissão: 28/09/12                 
	// EMPRESA //                  TITULO DO RELATORIO             Hora...: 09:54:41
	//*********//*******************************************************************

	//Imprime linhas separadoras
	oRpt:Line(nLin    ,nHM,nLin    ,nFH,,cEspLin)  //=============================
	oRpt:Line(nLin+001,nHM,nLin+001,nFH,,cEspLin)
	nLin	+= nIncLin

	oRpt:Say(nLin,nFH-nTab1,"Página......:"  			,oFonte11N)
	oRpt:Say(nLin,nFH-nTab2,StrZero(oRpt:nPageCount,3)	,oFonte11 )
	oRpt:SayC(nLin,nHM,cNomeEmp     					,oFonte12N, nLP )
	nLin	+= nIncLin

	oRpt:Say(nLin,nFH-nTab1,"Impressão:"    			,oFonte11N)
	oRpt:Say(nLin,nFH-nTab2,DtoC(Date())   				,oFonte11 )
	nLin	+= nIncLin/2

	oRpt:SayC(nLin,nHM,oRpt:cTitulo					  	,oFonte14N, nLP )
	nLin	+= nIncLin/2

	oRpt:Say(nLin,nFH-nTab1,"Hora..........:"			,oFonte11N)
	oRpt:Say(nLin,nFH-nTab2,Time()         				,oFonte11 )
	nLin	+= nIncLin/2
	
	//Imprime linha separadora
	oRpt:Line(nLin    ,nHM,nLin    ,nFH,,cEspLin)  //=============================
	oRpt:Line(nLin+001,nHM,nLin+001,nFH,,cEspLin)
	nLin	+= nIncLin/2

Return nLin

//-------------------------------------------------------------------------------------------------
// Impressao do rodape do relatorio em PDF
//-------------------------------------------------------------------------------------------------
Static Function RodapeGrf()

	//Linha final do relatorio ou pagina
	oRpt:Line(nFV-002,nHM,nFV-002,nFH,,cEspLin)
	oRpt:Line(nFV-001,nHM,nFV-001,nFH,,cEspLin)
	oRpt:Line(nFV-000,nHM,nFV-000,nFH,,cEspLin)

Return nFV
*/
