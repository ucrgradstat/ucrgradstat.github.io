# UCR Statistics GSA Website Repository

This Repository contains all the files to construct the website:
[ucrgradstat.github.io](https://ucrgradstat.github.io/)

## Building the Website

The website is a collection of R Markdown files. The website is built
using [Quarto](quarto.org). Make changes to Q Markdown files to update
the website. Then use the code below to build the website:

    quarto::quarto_render()

You may also build the website from the build tab. Make sure to build
the website before pushing to GitHub.

## Configuring `_quarto.yml`

The `_quarto.yml` file contains all the information needed to build the
website. Make sure to keep the following lines:

    project:
        type: website
        output-dir: docs
        render: 
        - index.qmd
        - gss.qmd
        - newsletter.qmd
        - officers.qmd
        - statistical.qmd
        - university.qmd
        - career.qmd

These lines tells Quarto how to build the website. The `output-dir`
indicates where to put the built website, and `render` indicates which
files need to be built. If any new files need to be built, add them to
the `render` section.

## Tips for Building Website

-   Use `.gitignore` to ignore cache folders from files

-   Use `styles.css` to change the appearance of the website
