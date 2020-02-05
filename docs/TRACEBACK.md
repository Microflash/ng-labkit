# Traceback

> A TRACEBACK is a file containing a series of steps to recreate a project from scratch

1. [Generate the project with Angular CLI](#generate-the-project-with-angular-cli)
2. [Add Ant Design](#add-ant-design)
3. [Code formatting](./stories/code-formatting.md)
4. [Continuous Integration](./stories/continuous-integration.md)
5. [Code Coverage](./stories/code-coverage.md)

## Generate the project with Angular CLI

Run the following script to generate the project with routing and SASS support, and Ivy Renderer enabled.

```sh
ng new ng-labkit --routing=true --style=less --enableIvy=true
```

> **WARNING** Ivy is not supported by Angular Universal; don't enable it if you want an SSR app.

## Add Ant Design

Install And Design dependencies with the following command and answer the questions that follow it:

```sh
$ ng add ng-zorro-antd
? Add icon assets [ Detail: https://ng.ant.design/components/icon/en ] Yes
? Set up custom theme file [ Detail: https://ng.ant.design/docs/customize-theme/en ] Yes
? Choose your locale code: en_US
? Choose template to create project: blank
```
