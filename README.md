# Example Frontend

This is a React frontend application built with [Vite](https://vitejs.dev/). The app allows you to interact with an API by setting a configurable **base URL** at build time using environment variables.

## Table of Contents

- [Installation](#installation)
- [Development](#development)
- [Building](#building)
- [Preview](#preview)
- [Environment Variables](#environment-variables)

## Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/yourusername/example-frontend.git
   ```

2. Navigate into the project directory:

   ```bash
   cd example-frontend
   ```

3. Install dependencies using **npm**:

   ```bash
   npm install
   ```

## Development

To run the app in development mode, use the following command:

```bash
npm run dev
```

This will start the app using **Vite**'s development server. You can access it at `http://localhost:3000` by default.

## Building

To build the application for production, run:

```bash
npm run build
```

This will generate the optimized build files in the `dist/` folder.

## Preview

After building the app, you can preview it locally using:

```bash
npm run preview
```

This will start a local server to preview the production build.

## Environment Variables

The **base API URL** is configurable via an environment variable at build time. You can set it in the `.env` file.

### Vite Environment Variable

In order to set the base URL for the API, define the `VITE_API_BASE_URL` variable in the `.env` file. This will be injected during the build process.

Important: Do not include a trailing slash at the end of the URL. Including a trailing slash may cause frontend errors when paths are appended.

- **.env**:

  ```env
  VITE_API_BASE_URL=http://localhost:5050
  ```

### Using the Base URL in Your React Code

In your React components, you can access the **base URL** using the following:

```javascript
const response = await fetch(`${import.meta.env.VITE_API_BASE_URL}/record/`);
```

This ensures that the base URL is injected correctly depending on the environment.
