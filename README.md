# TaskWahser

taskwasherは指定したリポジトリ一覧に対し、自分がアサインされているIssueを洗い出すツールです

repsitories.txtに改行区切りでリポジトリを記載すると、
Issue一覧を出力します

# Usage

Issue一覧を表示

```
sh taskwasher.sh
```

Issue一覧を表示し、全部ブラウザで開く
```
sh taskwasher.sh --open
```

Issue一覧をClaudeに投げて対処してもらう

```
sh claude.sh
```

# requirements

ghコマンドが利用できる前提で作られています
