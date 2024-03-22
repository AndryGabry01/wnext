#!/bin/sh

# Set the required environment variables for Next.js

# Navigate to the directory containing the Next.js app
cd "$NextJsAppName" || exit 1

# Install dependencies
npm install || exit 1

# Function to check and replace a command in package.json
check_and_replace_command() {
    local command="$1"
    local replacement="$2"
    if ! grep -q "$replacement" package.json; then
        sed -i "s/\"$command\"/\"$replacement\"/" package.json
    fi
}

# Check and replace "next dev" command
check_and_replace_command "next dev" 'next dev -p $NextJsInternalPort'

# Check and replace "next start" command
check_and_replace_command "next start" 'next start -p $NextJsInternalPort'

# Execute the appropriate command based on NextRunMode
case "$NextRunMode" in
    "dev")
        # Run the Next.js development server
        npm run dev
        ;;
    "build")
        # Run the Next.js build command
        npm run build
        ;;
    "start")
        # Run the Next.js start command
        npm start
        ;;
    "lint")
        # Run linting for the Next.js project
        npm run lint
        ;;
    *)
        echo "Error: Unsupported NextRunMode. Supported modes are: 'dev', 'build', 'start', 'lint'"
        exit 1
        ;;
esac
