# Traceback

> A TRACEBACK is a file containing a series of steps to recreate a project from scratch

- [Generate the project with Angular CLI](#generate-the-project-with-angular-cli)

## Generate the project with Angular CLI

Run the following script to generate the project with routing and SASS support, and Ivy Renderer enabled.

```sh
ng new ng-labkit --routing=true --style=scss --enableIvy=true
```

> **WARNING** Ivy is not supported by Angular Universal; don't enable it if you want an SSR app.