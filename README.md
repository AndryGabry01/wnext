
# WNEXT - Gestore di un'ambiente di sviluppo Dockerizzato NextJs  
WNEXT è uno script Bash progettato per semplificare lo sviluppo di web app basate su Next.js in un ambiente dockerizzato.
 Questo strumento è stato creato per gestire in modo efficiente il processo di sviluppo, consentendo agli sviluppatori di concentrarsi sulla creazione della webApp.
  
  
## Caratteristiche Principali  
- **Facilità d'Uso:** WNEXT offre comandi intuitivi e diretti, permettendo agli sviluppatori di avviare, fermare e gestire facilmente l'ambiente di sviluppo.  
- **Ambiente Dockerizzato:** Utilizzando Docker, WNEXT garantisce un ambiente isolato e portatile per lo sviluppo delle applicazioni Next.js, eliminando la necessità di configurazioni manuali complesse.  
- **Configurazione Automatica (o Quasi):** Con un semplice comando, WNEXT crea automaticamente il file Docker Compose e configura il progetto Next.js, risparmiando tempo prezioso.  
- **Aggiunta di Microservizi:** WNEXT consente l'aggiunta rapida e semplice di microservizi aggiuntivi al progetto, offrendo flessibilità nell'integrazione di servizi aggiuntivi.  
- **Personalizzazione Flessibile:** WNEXT offre opzioni per personalizzare le impostazioni di Next.js, come la modalità di esecuzione e le porte, per adattarle alle esigenze specifiche del progetto.  

## Utilizzo
### Pre-Requisiti
1. [Docker](https://www.docker.com/products/docker-desktop/)
2. [Docker-Compose](https://docs.docker.com/compose/)
3. Sistema linux con shell Bash
### Uso
1. Per iniziare, assicurati di avere Docker e Bash installati sul tuo sistema. 
2.   Scarica il repository di WNEXT sul tuo computer. 
3. Esegui quindi lo script WNEXT utilizzando il comando `./wnext help` per visualizzare l'elenco completo dei comandi disponibili e le relative istruzioni.
4. Esegui `./wnext app setup` per il primo avvio.
### Aggiungere micro-servizi
Nel caso si voglia utilizzare il micro-servizio di Next.js in combinazione con un altro micro-servizio (ES: Redis), bisogna seguire il seguente procedimento:
1. `./wnext.sh app addMicroservice`
2. Inserire il nome che si vuole dare al micro servizio (es: Alpine)
3. Lo script creerà, nella cartella Project, una cartella contenente il file DockerFile e entrypoint.sh.
	- DockerFile e entryfile, conterranno un template d'esempio che andrà sostituito in base alle proprie esigenze, ad esempio inserendo l'immagine di Alpine 
4. Lo script genererà anche la parte iniziale di definizione del micro-servizio all'interno del file docker-compose.base.yml, 
5. Infine sarà possibile avviare la webApp tramite il comando `./wnext app start`
### Lingue
All'avvio lo script carica il file {Lingua].lang (es: en.lang), dalla cartella **.langs**, in base al valore impostato all'interno del file **vars.txt** . 
In questo modo lo script è facilmente traducibile in più lingue. 
Al momento sono presenti i file .lang per:
- Italiano
- Inglese
## Stuttura cartelle
- root
	- Project
		- .docker-compose.yml
		- NextJS
			- DOCKERFILE
			- entrypoint.js
		- EventualiAltriMicroServizi
			- DOCKERFILE
			- entrypoint.js
		- ......
	- placeholders.txt
	- vars.txt
	- wnext.sh
	- docker-compose.base.yml
	- config
		- vars.txt_backup
		- placeholders.txt_backup
		- docker-compose.base.yml_backup
	- langs
		- it.lang
		- en.lang

## Contribuire

Se desideri contribuire a WNEXT, puoi aprire una nuova issue o inviare una pull request sul repository GitHub. Ogni contributo è benvenuto e aiuta a migliorare lo strumento per tutti gli sviluppatori.
## Stato e Avvertimenti

WNEXT è attualmente in una fase embrionale e molto rudimentale. Potrebbe contenere numerosi problemi logici e funzionali. Tuttavia, con il tempo, è probabile che venga migliorato e affinato per offrire una migliore esperienza agli sviluppatori. Si consiglia di utilizzarlo con cautela e di segnalare eventuali problemi riscontrati per contribuire al suo miglioramento.
 
## Licenza

WNEXT è rilasciato sotto la licenza GNU General Public License (GPL), che significa che puoi utilizzarlo, copiarlo, modificarlo e distribuirlo liberamente secondo i termini della licenza. Assicurati di leggere attentamente i termini della licenza prima di utilizzare questo software.
## TODO  

- [ ]  aggiornare i file di lingua con le frasi aggiunte in seguito
- [ ] Migliorare l'output e risolvere i problemi generali
- [ ] Completare il sistema multi lingua
- [ ] Aggiungere i comandi per ripristinare i file docker-compose.base.yml, vars.txt e placeholders.txt
- [ ]  Alcuni servizi, come redis, potrebbero non richiedere la creazione di un DOCKERFILE o di un entrypoint. per risolvere questo problema, chiedere ulteriori informazioni al momento della creazione del microservizio (ES: Immagine, se ha bisogno di un dockerfile e così via).
- [x] CREATE README.md
- [ ] Complete the readme file
- [ ] Aggiungere controllo e gestione degli errori, ad esempio se uno prova ad avviare l'app senza che sia stata prima generata l'app nextjs tramite l'apposito comando setup
