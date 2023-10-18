module.exports = {
  content: [
    "./app/views/**/*.erb",
    "./app/helpers/**/*.rb",
    "./app/decorators/**/*.rb",
    "./app/assets/**/*.svg",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "./app/javascript/**/*.ts",
    "./app/components/**/*",
  ],
  plugins: [require("@tailwindcss/forms")] 
};
