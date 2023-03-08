# Repro for sorting issue in i18next-parser

This acts as a minimal reproducible example for an issue with
[i18next-parser](https://github.com/i18next/i18next-parser/issues).

The repo has been initialized with translations in locales/en using

```sh
LC_ALL=en_EN npm run init-translations
```
which creates the english translation file with keys from index.js. 

Running 

```sh
LC_ALL=en_EN npm run update-translations
```
will look for new translations in other.js and update the english translations file.

After running that, you can run 

```sh
git diff
```
to verify that the new translation has been added correctly.  

The diff will look like this:

```diff
diff --git a/locales/en/translation.json b/locales/en/translation.json
index 69b38a7..1800116 100644
--- a/locales/en/translation.json
+++ b/locales/en/translation.json
@@ -1,4 +1,5 @@
 {
   "ä": "",
-  "b": ""
+  "b": "",
+  "c": ""
 }
```

Run
```sh
git reset --hard HEAD
```
after that so that the next step gets to run without the new translation key
already being in the file.


## The issue

Now, try adding a new translation key from the other.js file, but this time with
Finnish system locale. Finnish is used as an example here, but the same should
happen in many other locales too that don't sort "ä" next to "a", such as
Swedish. 

```sh
LC_ALL=fi_FI npm run update-translations
```

If you don't have Finnish locale settings installed, you can also use the provided
Dockerfile to run this in docker:

```sh
docker run --rm -it \
  --mount type=bind,source=$(pwd),target=/app $(docker build -q .) \
  bash -c 'cd /app && npm run update-translations'
```

Run `git diff` again. Now, the diff will now look like this

```diff
diff --git a/locales/en/translation.json b/locales/en/translation.json
index 69b38a7..3ef3c9c 100644
--- a/locales/en/translation.json
+++ b/locales/en/translation.json
@@ -1,4 +1,5 @@
 {
-  "ä": "",
-  "b": ""
+  "b": "",
+  "c": "",
+  "ä": ""
 }
```
The "ä" key has switched places, even though the actual change of
adding new key "c" has nothing to do with it.
