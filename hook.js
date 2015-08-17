var gith = require('gith').create(9001);
var execFile = require("child_process").execFile;
var args = require('minimist')(process.argv.slice(2));

var repo = args.r || "";
var branch =  args.b || "";

console.log(args, repo, branch);

if (repo === "" || branch === "") {
	console.log("Repo and branch can't be blank");
	return;
}

gith({
	repo: repo,
	branch: branch
}).on('all', function(payload) {
	console.log(payload);
	if(payload.branch === branch) {
		execFile('./hook.sh ' + repo + " " + branch, function(error, stdout, stderr) {
			console.log("exec complete");
		})
	}
});
