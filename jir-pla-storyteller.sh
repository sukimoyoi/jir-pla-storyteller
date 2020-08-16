#!/bin/bash

jir_userid="" #JIRAのユーザーID
jir_password="" #JIRAのパスワード
pla_cookie="" #planitpokerのCookie
jir_url="" #JIRAのURL。たとえば https://www.hoge.com/jira"
project_name="" #JIRAのプロジェクトの名前
maxResult=15 #JIRAで取得するデータの件数

sprint_name=$1 #スプリントの名前
#sprint_number=$1 #課題ナビゲーターのアドバンスの検索条件から「スプリント」を選ぶと表示できる（スプリントIDじゃなくてもスプリント名で検索可能）
pla_title=$2 #planitpokerの部屋の名前

stories=()

#JIRAのAPI叩く
jir_data=`curl  -sS -u "$jir_userid:$jir_password" \
                -G \
                --data-urlencode "jql=project=$project_name AND resolution=Unresolved AND スプリント=\"$sprint_name\" ORDER BY ランク ASC" \
                --data "maxResults=$maxResults" \
                --data "fields=summary" \
                "$jir_url/rest/api/2/search" | jq ".issues"`

if [ "$jir_data" == null ]; then
  echo "Error: Failed to get JIRA datas."
  exit 1
fi

for i in `seq 0 $(expr $(echo "$jir_data" | jq length) - 1 )`
do
  stories+=( $(echo "$jir_data" | jq ".[$i].fields.summary" | sed 's/"//g' | sed 's/ /%20/g') )
done


# Cookieと部屋名を使ってplanitpokerのAPIを叩く
pla_data=`curl -sS -X POST -H "cookie: $pla_cookie" -H "content-Length: 0"  https://www.planitpoker.com/api/games/getList/`

#gameId取得
for i in `seq 0 $(expr $(echo "$pla_data" | jq length) - 1 )`; do
  if [ \"$pla_title\" == `echo "$pla_data" | jq ".[$i].title"` ] ; then
    gameId=`echo "$pla_data" | jq ".[$i].gameId"`
    break
  fi
done


#gemeIdとCookie使って、JIRAのタスク名をstoryとして追加
for story in ${stories[@]}; do
  echo "Add [ $(echo $story | sed 's/%20/ /g') ]"
  curl -sS -X POST -H "cookie: $pla_cookie" -d "gameId=$gameId" -d "name=$story" https://www.planitpoker.com/api/stories/create/ > /dev/null
done
