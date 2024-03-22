#!/usr/bin/env bash

# Definizione delle variabili
SCRIPT_NAME="./wnext"
DOCKER_COMPOSE_PATH="./Project/.docker-compose.yml"
PLACEHOLDERS_FILE_PATH="./placeholders.txt"
ENV_VARS_FILE_PATH="./vars.txt"

# Caricamento delle variabili di ambiente
source "$PLACEHOLDERS_FILE_PATH"
source "$ENV_VARS_FILE_PATH"
source "./langs/it.lang"
# Funzione per visualizzare l'header dell'help
function display_header_help {
    #echo "$SCRIPT_NAME"
    echo
    echo "$HELP_HEADER_1" >&2
    echo "  $SCRIPT_NAME $HELP_HEADER_2"
    echo
}

# Funzione per visualizzare l'help relativo agli App Commands
function display_app_help {
    echo "$HELP_APP_1:"
    echo "  $SCRIPT_NAME app setup                       $HELP_APP_2"
    echo "  $SCRIPT_NAME app addMicroservice             $HELP_APP_3"
    echo "  $SCRIPT_NAME app start                       $HELP_APP_4"
    echo "  $SCRIPT_NAME app startInBackground           $HELP_APP_5"
    echo "  $SCRIPT_NAME app stop                        $HELP_APP_6"
    echo "  $SCRIPT_NAME app down                        $HELP_APP_7"
    echo "  $SCRIPT_NAME app restart                     $HELP_APP_8"
    echo
}

# Funzione per visualizzare l'help relativo ai Docker-compose Commands
function display_dc_help {
    echo "$HELP_DC_1"
    echo "  $SCRIPT_NAME dc up                           $HELP_DC_2"
    echo "  $SCRIPT_NAME dc up -d                        $HELP_DC_3"
    echo "  $SCRIPT_NAME dc stop                         $HELP_DC_4"
    echo "  $SCRIPT_NAME dc down                         $HELP_DC_5"
    echo "  $SCRIPT_NAME dc restart                      $HELP_DC_6"
    echo "  $SCRIPT_NAME dc ps                           $HELP_DC_7"
    echo "  $SCRIPT_NAME dc $HELP_DC_8"
    echo
}

# Funzione per visualizzare l'help relativo ai Node Commands
function display_node_help {
    echo "$HELP_NODE_1"
    echo "  $SCRIPT_NAME node $HELP_NODE_2"
    echo "  $SCRIPT_NAME node --version                  $HELP_NODE_3"
    echo
}

# Funzione per visualizzare l'help relativo ai Npm Commands
function display_npm_help {
    echo "$HELP_NPM_1"
    echo "  $SCRIPT_NAME npm $HELP_NPM_2"
    echo "  $SCRIPT_NAME npm test                        $HELP_NPM_3"
    echo
}

# Funzione per visualizzare l'help relativo ai NextJs Commands
function display_nextjs_help {
    echo "$HELP_NEXTJS_1"
    echo "  $SCRIPT_NAME nextjs mode $HELP_NEXTJS_2"
    echo "  $SCRIPT_NAME nextjs externalport $HELP_NEXTJS_3"
    echo "  $SCRIPT_NAME nextjs internalport $HELP_NEXTJS_4"
    echo
}

# Funzione per visualizzare l'help relativo alla Customization
function display_customization_help {
    echo "$HELP_CUSTOM_1"
    echo "  $SCRIPT_NAME dc build --no-cache             $HELP_CUSTOM_2"
    echo
}

# Funzione per visualizzare l'help completo
function display_help {

    display_header_help
    # Visualizza l'help per ogni sezione
    display_app_help
    display_dc_help
    display_node_help
    display_npm_help
    display_nextjs_help
    display_customization_help
    exit 1
}


# Funzione per verificare se il nome del progetto è valido per Next.js
function check_next_project_name {
    # Controlla se il nome del progetto è alfanumerico, inizia con una lettera e non contiene trattini o underscore all'inizio o alla fine
    if ! [[ $1 =~ ^[a-zA-Z][a-zA-Z0-9]*(-[a-zA-Z0-9]*)?$ ]]; then
        echo "$CHECK_NEXT_PROJECT_NAME_1"
    fi

    # Controlla se il nome del progetto è una parola riservata di Next.js
    if [ "$1" == "next" ] || [ "$1" == "pages" ]; then
        echo "$CHECK_NEXT_PROJECT_NAME_2"
        exit 1
    fi

    # Se il controllo è andato a buon fine, esce dallo script con status 0
    return 0
}

# Funzione per verificare il valore di NextRunMode
function check_next_run_mode {
    case "$1" in
    "dev" | "build" | "start" | "lint")
        echo "$CHECK_NEXT_RUN_MODE_1 '$NextRunMode'"
        ;;
    *)
        echo "$CHECK_NEXT_RUN_MODE_2"
        exit 1
        ;;
    esac
}

# Funzione per creare un nuovo progetto Next.js
function create_nextjs_app {
    echo "$CREATE_NEXT_APP_1 '$NextJsAppName'"
    npx create-next-app@latest "Project/NextJs/$NextJsAppName"
    exit 1
}

# Funzione per cambiare un qualsiasi placeholder nel file
function change_placeholder {
    if [ ! -f "$PLACEHOLDERS_FILE_PATH" ]; then
        echo "$CHANGE_PLACEHOLDER_1 '$PLACEHOLDERS_FILE_PATH' $CHANGE_PLACEHOLDER_2"
        return 1
    fi

    if ! grep -q "^$1=" "$PLACEHOLDERS_FILE_PATH"; then
        echo "$CHANGE_PLACEHOLDER_3 '$1' $CHANGE_PLACEHOLDER_4 '$PLACEHOLDERS_FILE_PATH'"
        return 1
    fi

    sed -i "s/^$1=.*/$1=$2/" "$PLACEHOLDERS_FILE_PATH"
    source "$PLACEHOLDERS_FILE_PATH"
    echo "'$1' $CHANGE_PLACEHOLDER_5 '$2'"
}

# Funzione per generare il file Docker Compose
# Funzione per generare il file Docker Compose
function make_dockerfile {
    check_next_project_name "$NextJsAppName"
    check_next_run_mode "$NextRunMode"

    base_file="./docker-compose.base.yml"
    content=$(< "$base_file")

    while IFS= read -r line; do
        # Ignora le righe che iniziano con #
        if [[ $line =~ ^\s*# ]]; then
            continue
        fi

        placeholder_name=$(echo "$line" | cut -d'=' -f1)
        placeholder_value=$(echo "$line" | cut -d'=' -f2)
        content=$(echo "$content" | sed -e "s/%$placeholder_name%/$placeholder_value/g")
    done < "$PLACEHOLDERS_FILE_PATH"

    echo -e "$content" > "$DOCKER_COMPOSE_PATH"
}


function add_microservice {
    # Richiedi all'utente il nome del microservizio
    echo "$ADD_MICROSERVICE_1"
    read microservice_name

    # Crea una cartella per il microservizio nella directory Project
    mkdir -p "./Project/$microservice_name"

    # Crea un file Dockerfile nella cartella del microservizio
    touch "./Project/$microservice_name/Dockerfile"

    # Crea un file entrypoint.sh nella cartella del microservizio
    touch "./Project/$microservice_name/entrypoint.sh"

    # Aggiungi il contenuto allo script entrypoint.sh
    echo "#!/bin/sh" > "./Project/$microservice_name/entrypoint.sh"
    echo >> "./Project/$microservice_name/entrypoint.sh"
    echo "#Usa #!/bin/sh se stai usando un immagine basata su Alphine" >> "./Project/$microservice_name/entrypoint.sh"
    echo "# Usa #!/bin/bash se stai usando un immagine basata tipo su fedora" >> "./Project/$microservice_name/entrypoint.sh"

    # Aggiungi il contenuto allo script Dockerfile
    echo "FROM NOME_IMMAGINE" > "./Project/$microservice_name/Dockerfile"
    echo >> "./Project/$microservice_name/Dockerfile"
    echo "WORKDIR /app/$microservice_name" >> "./Project/$microservice_name/Dockerfile"
    echo >> "./Project/$microservice_name/Dockerfile"
    echo "COPY . ." >> "./Project/$microservice_name/Dockerfile"
    echo >> "./Project/$microservice_name/Dockerfile"
    echo "ENTRYPOINT [\"./entrypoint.sh\"]" >> "./Project/$microservice_name/Dockerfile"

    # Aggiungi il servizio al file docker-compose.base.yml
    echo "  $microservice_name:" >> ./docker-compose.base.yml
    echo "    build:" >> ./docker-compose.base.yml
    echo "      context: ./Project/$microservice_name" >> ./docker-compose.base.yml
    echo "      dockerfile: Dockerfile" >> ./docker-compose.base.yml
    echo "    container_name: nextjsContainer_$microservice_name" >> ./docker-compose.base.yml

    # Visualizza un messaggio di conferma
    echo "$ADD_MICROSERVICE_2 '$microservice_name' $ADD_MICROSERVICE_3."

    # Fornisci istruzioni per configurare il microservizio nei file Docker Compose, Dockerfile e entrypoint.sh
    echo
    echo "$ADD_MICROSERVICE_4"
    echo "  - docker-compose.base.yml: $ADD_MICROSERVICE_5"
    echo "  - ./Project/$microservice_name/Dockerfile: $ADD_MICROSERVICE_6"
    echo "  - ./Project/$microservice_name/entrypoint.sh: $ADD_MICROSERVICE_7"
}


if [ $# -gt 0 ]; then
    case "$1" in
    "npm")
        shift 1
        sudo docker-compose run --rm app npm "$@"
        ;;
    "node")
        shift 1
        sudo docker-compose run --rm app node "$@"
        ;;
    "app")
        case "$2" in
        "setup")
            make_dockerfile
            create_nextjs_app
            exit 1
            ;;
        "addMicroservice")
            add_microservice
            exit 1
            ;;
        "start")
            make_dockerfile
            sudo docker-compose -f "$DOCKER_COMPOSE_PATH" up
            ;;
        "startInBackground")
            make_dockerfile
            sudo docker-compose -f "$DOCKER_COMPOSE_PATH" up -d
            ;;
        "stop")
            make_dockerfile
            sudo docker-compose -f "$DOCKER_COMPOSE_PATH" stop
            ;;
        "down")
            make_dockerfile
            sudo docker-compose -f "$DOCKER_COMPOSE_PATH" down
            ;;
        "restart")
            make_dockerfile
            sudo docker-compose -f "$DOCKER_COMPOSE_PATH" restart
            ;;
        *)
            echo "Error: Invalid sub-command for 'app'."
            display_header_help
            display_app_help
            ;;
        esac
        ;;
    "nextjs")
        case "$2" in
        "mode")
            check_next_run_mode "$3"
            change_placeholder "NextRunMode" "$3"
            ;;
        "externalport")
            change_placeholder "NextJsExternalPort" "$3"
            ;;
        "internalport")
            change_placeholder "NextJsInternalPort" "$3"
            ;;
        *)
          display_header_help
          display_nextjs_help
        ;;

        esac
        exit 0
        ;;
    "dc")
        shift 1
        sudo docker-compose -f "$DOCEKR_COMPOSE_PATH" "$@"
        ;;
    "help" | "--help" | "-h")
        display_help
        ;;
    *)
        display_help
        ;;
    esac
else
    display_help
fi


