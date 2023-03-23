# CXRelGraf

Este é um conjunto de funções e classes utilizadas para **geração simplificada de relatórios gráficos***. O processo de geração torna-se muito semelhante a relatórios legado/texto, e é feito apenas utilizando arreis. No projeto aqui tem até um exemplo de como utilizar os diversos métodos de impressão.

A inspiração para sua criação veio do funcionamento do próprio fonte da impressão do Danfe, onde já existia essa idéia de alimentar arreis com os dados seguindo uma certa estrutura e esta se refletia em box que seriam impressos dinamicamente no momento da geração do relatório. Esta metodologia simplifica demais a criação e manutenção de relatórios gráficos, já que deixa a cargo do programa fazer todo o processo de diagramação.

Como **bônus** as classes CXMsPrinter e CXPrintSetup permite funções de personalização da tela de impressão e deixam as configurações devidamente salvas. Configurações como qual a última impressora, último diretório e última seleção (PDF ou Spool) ficam todas devidamente salvas no profile do usuário. Os fontes padrão também permitem essa característica, porém, é necessário escrever muito código para que isso funcione, e repetir todo esse mecanismo em cada relatório não é uma prática interessante. Desta forma as duas classes citadas empasulam toda essa mecânica e deixam no relatório exclusivamente a sua impressão.

As duas classes foram desenvolvidas para ter o máximo de compatibilidade com as classes padrão FWMsPrinter e FWPrintSetup, de modo que a adaptação de outros fontes para tirar proveito destas características é muito simples e requer quase nenhuma recodificação.





**Da forma que está atualmente talvez ainda precise de alguns retoques para funcione em qualquer ambiente, além do [CXLibCore](https://github.com/cirilorocha/CXLibCore)**
