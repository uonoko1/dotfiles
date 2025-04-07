const express = require("express");
const { exec } = require("child_process");
const app = express();
const server = require("http").createServer(app);
const PORT = 65535;

// JSON ボディのパースを有効にする
app.use(express.json());

app.post("/sync", (req, res) => {
  const settingsCommand = `rsync -av "/mnt/c/Users/sakai/AppData/Roaming/Code/User/settings.json" "${process.env.HOME}/dotfiles/vscode/settings.json" && echo "$(basename '/mnt/c/Users/sakai/AppData/Roaming/Code/User/settings.json') synchronized at $(date)"`;
  const keybindingsCommand = `rsync -av "/mnt/c/Users/sakai/AppData/Roaming/Code/User/keybindings.json" "${process.env.HOME}/dotfiles/vscode/keybindings.json" && echo "$(basename '/mnt/c/Users/sakai/AppData/Roaming/Code/User/keybindings.json') synchronized at $(date)"`;
  const command = `${settingsCommand} && ${keybindingsCommand}`;

  // rsync コマンドを実行する
  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error executing command: ${stderr}`);
      res.status(500).send(stderr);
    } else {
      console.log(`Command output: ${stdout}`);
      res.send(stdout);
    }
  });
});

server.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
