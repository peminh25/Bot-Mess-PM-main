module.exports.config = {
  name: "setluot",
  version: "1.0.0",
  hasPermssion: 2,
  credits: "Ỏ",
  description: "set lượt dùng bot",
  usages: "[me/tag] [số lượt]",
  commandCategory: "admin",
  cooldowns: 5
};

const fs = require("fs");
const path = __dirname + '/../../includes/handle/usages.json';

module.exports.onLoad = () => {
  if (!fs.existsSync(path)) fs.writeFileSync(path, JSON.stringify({}));
}

module.exports.run = async ({ event, api, args }) => {
  const { threadID, messageID, senderID } = event;
  if (args.length < 2) return api.sendMessage("Thiếu input!", threadID, messageID);
  var targetID = 0, num = 0;
  const userID = Object.keys(event.mentions)[0];
  if (args[0] == "me") {
    targetID = senderID;
    num = parseInt(args[1]);
  } else if (userID) {
    targetID = userID;
    let nameL = event.mentions[userID].split(" ").length;
    num = parseInt(args[nameL]);
  } else return api.sendMessgae("Lựa chọn của bạn không hợp lệ", threadID, messageID);

  if (isNaN(num)) return api.sendMessage("Không phải là 1 con số", threadID, messageID);
  let dataM = JSON.parse(fs.readFileSync(path));
  if (!(targetID in dataM)) {
    let getDay = require("moment-timezone").tz("Asia/Ho_Chi_Minh").day();
    dataM[targetID] = {
      day: getDay,
      usage: num
    }
  } else dataM[targetID].usages = num;
  fs.writeFileSync(path, JSON.stringify(dataM, null, 4));
  return api.sendMessage(`Đã set cho ${((userID) ? event.mentions[userID].replace(/@/g, "") : "bản thân") + " " + num} lượt dùng bot`, threadID, messageID);
}
