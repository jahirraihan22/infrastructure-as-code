```sh

for i in $(cat /tmp/assets/names.txt)
do
    bash /home/bob/create-and-launch-rocket $i
done

```

```sh

for i in {31..40}
do
        echo $i
done

```


```sh

echo -e " Log name   \t      GET      \t      POST    \t   DELETE "
echo -e "------------------------------------------------------------"

for app in $(cat /tmp/assets/apps.txt)
do
  get_requests=$(cat /var/log/apps/${app}_app.log | grep "GET" | wc -l)
  post_requests=$(cat /var/log/apps/${app}_app.log | grep "POST" | wc -l)
  delete_requests=$(cat /var/log/apps/${app}_app.log | grep "DELETE" | wc -l)
  echo -e " ${app}    \t ${get_requests}    \t    ${post_requests}   \t   ${delete_requests}"

done

```
