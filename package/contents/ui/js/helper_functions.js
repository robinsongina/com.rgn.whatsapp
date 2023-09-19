document.userScripts={saveData:{},config:{}};
document.userScripts.setTheme = function (theme) {
	if( document.userScripts.config && document.userScripts.config.matchTheme && theme ) {
		let themeT = theme === 'dark' ? 'web dark' : 'web'
		localStorage.setItem('theme', '"' + theme + '"');
		
		setTimeout(() => {
			document.querySelector('body').classList = themeT;
			console.log("Set theme", localStorage.getItem('theme'), document.querySelector('body').classList.value)
			// if(document.querySelector('body').classList.value !== themeT){
			// 	document.querySelector('body').classList = themeT;
			// }
		}, 1000);
	}
}

document.userScripts.getTheme = function () {
	return localStorage.getItem('theme');
}

document.userScripts.setConfig = function (configuration) {
	document.userScripts.config = configuration;
	// console.log('setConfig : ' + JSON.stringify(configuration));
}

// console.log('Helper Functions loaded');
