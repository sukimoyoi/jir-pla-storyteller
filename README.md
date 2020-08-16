# jir-pla-storyteller

Jiraからタスク名を取得してPlanITpokerのストーリーとして追加する。ストーリーはバックログのRank順。

## Usage

ソースファイル中に各値をセットする

|Variable|Description|
|:--|:--|
|jir_userid|JIRAのユーザーID|
|jir_password|JIRAのパスワード|
|pla_cookie|planitpokerのCookie|
|jir_url|JIRAのURL。たとえば https://www.hoge.com/jira|
|project_name| JIRAのプロジェクトの名前|


実行時引数を2つ与える　

  - JIRAのスプリント名
  - plan IT pokerの部屋の名前


## Example

```sh
$ ./jir-pla-storyteller.sh "HELLOスプリント 1(10/2-10/16)" "room1"
Add [ Task1 ]
Add [ タスク2 ]
Add [ たすたす3 ]
$
```
