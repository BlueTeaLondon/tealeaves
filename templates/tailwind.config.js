module.exports = {
  darkMode: "class",
  content: [
    "./app/views/**/*.erb",
    "./app/helpers/**/*.rb",
    "./app/decorators/**/*.rb",
    "./app/assets/**/*.svg",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "./app/javascript/**/*.ts",
    "./app/components/**/*",
    "./lib/simple_form/builders/*.rb",
    "./config/locales/*.yml",
    "./config/initializers/heroicon.rb"
  ],
  plugins: [require("@tailwindcss/forms")] 
};
