if (document.body.innerText.replace(/\n/g, ' ').search(/whatsapp works with.*to use whatsapp.*update/i) !== -1) navigator.serviceWorker.getRegistration().then(function (r) { r.unregister(); document.location.reload() });

//Inject Code
let ModuleRaid=function(){function t(){return t=Object.assign||function(t){for(var e=1;e<arguments.length;e++){var n=arguments[e];for(var o in n)Object.prototype.hasOwnProperty.call(n,o)&&(t[o]=n[o])}return t},t.apply(this,arguments)}var e=function(){function e(e){var n,o=this;this.entrypoint=void 0,this.debug=void 0,this.strict=void 0,this.moduleID=Math.random().toString(36).substring(7),this.functionArguments=[[[0],[function(t,e,n){o.modules=n.c,o.constructors=n.m,o.get=n}]],[[1e3],(n={},n[this.moduleID]=function(t,e,n){o.modules=n.c,o.constructors=n.m,o.get=n},n),[[this.moduleID]]]],this.arrayArguments=[[[this.moduleID],{},function(t){Object.keys(t.m).forEach(function(e){try{o.modules[e]=t(e)}catch(t){o.log("[arrayArguments/1] Failed to require("+e+") with error:\n"+t+"\n"+t.stack)}}),o.get=t}],this.functionArguments[1]],this.modules={},this.constructors=[],this.get=void 0;var r={entrypoint:"webpackJsonp",debug:!1,strict:!1};"object"==typeof e&&(r=t({},r,e)),this.entrypoint=r.entrypoint,this.debug=r.debug,this.strict=r.strict,this.detectEntrypoint(),this.fillModules(),this.replaceGet(),this.setupPushEvent()}var n=e.prototype;return n.log=function(t){this.debug&&console.warn("[moduleRaid] "+t)},n.replaceGet=function(){var t=this;null===this.get&&(this.get=function(e){return t.modules[e]})},n.fillModules=function(){var t=this;if("function"==typeof window[this.entrypoint]?this.functionArguments.forEach(function(e,n){try{var o;if(t.modules&&Object.keys(t.modules).length>0)return;(o=window)[t.entrypoint].apply(o,e)}catch(e){t.log("moduleRaid.functionArguments["+n+"] failed:\n"+e+"\n"+e.stack)}}):this.arrayArguments.forEach(function(e,n){try{if(t.modules&&Object.keys(t.modules).length>0)return;window[t.entrypoint].push(e)}catch(e){t.log("Pushing moduleRaid.arrayArguments["+n+"] into "+t.entrypoint+" failed:\n"+e+"\n"+e.stack)}}),this.modules&&0==Object.keys(this.modules).length){var e=!1,n=0;if("function"!=typeof window[this.entrypoint]||!window[this.entrypoint]([],[],[n]))throw Error("Unknown Webpack structure");for(;!e;)try{this.modules[n]=window[this.entrypoint]([],[],[n]),n++}catch(t){e=!0}}},n.setupPushEvent=function(){var t=this,e=window[this.entrypoint].push;window[this.entrypoint].push=function(){var n=[].slice.call(arguments),o=Reflect.apply(e,window[t.entrypoint],n);return document.dispatchEvent(new CustomEvent("moduleraid:webpack-push",{detail:n})),o}},n.detectEntrypoint=function(){if(null==window[this.entrypoint]){if(this.strict)throw Error("Strict mode is enabled and entrypoint at window."+this.entrypoint+" couldn't be found. Please specify the correct one!");var t=Object.keys(window);if((t=t.filter(function(t){return t.toLowerCase().includes("chunk")||t.toLowerCase().includes("webpack")}).filter(function(t){return"function"==typeof window[t]||Array.isArray(window[t])})).length>1)throw Error("Multiple possible endpoints have been detected, please create a new moduleRaid instance with a specific one:\n"+t.join(", "));if(0===t.length)throw Error("No Webpack JSONP entrypoints could be detected");this.log("Entrypoint has been detected at window."+t[0]+" and set for injection"),this.entrypoint=t[0]}},n.searchObject=function(t,e){for(var n in t){var o=t[n],r=e.toLowerCase();if("object"!=typeof o){if(n.toString().toLowerCase().includes(r))return!0;if("object"!=typeof o){if(o.toString().toLowerCase().includes(r))return!0}else if(this.searchObject(o,e))return!0}}return!1},n.findModule=function(t){var e=this,n=[],o=Object.keys(this.modules);if(0===o.length)throw new Error("There are no modules to search through!");return o.forEach(function(o){var r=e.modules[o.toString()];if(void 0!==r)try{if("string"==typeof t)switch(t=t.toLowerCase(),typeof r){case"string":r.toLowerCase().includes(t)&&n.push(r);break;case"function":r.toString().toLowerCase().includes(t)&&n.push(r);break;case"object":e.searchObject(r,t)&&n.push(r)}else{if("function"!=typeof t)throw new TypeError("findModule can only find via string and function, "+typeof t+" was passed");t(r)&&n.push(r)}}catch(t){e.log("There was an error while searching through module '"+o+"':\n"+t+"\n"+t.stack)}}),n},n.findConstructor=function(t){var e=this,n=[],o=Object.keys(this.constructors);if(0===o.length)throw new Error("There are no constructors to search through!");return o.forEach(function(o){var r=e.constructors[o];try{"string"==typeof t?(t=t.toLowerCase(),r.toString().toLowerCase().includes(t)&&n.push([e.constructors[o],e.modules[o]])):"function"==typeof t&&t(r)&&n.push([e.constructors[o],e.modules[o]])}catch(t){e.log("There was an error while searching through constructor '"+o+"':\n"+t+"\n"+t.stack)}}),n},e}();return e}();

const mR = new ModuleRaid()

window.Store = Object.assign({}, mR.findModule(m => m.default && m.default.Chat)[0].default);
window.Store.WidFactory = mR.findModule('createWid').filter((m)=>m.createWid !== undefined)[0]
window.Store.User = mR.findModule('getMaybeMeUser').filter((m)=>m.getMaybeMeUser !== undefined)[0]
window.Store.MsgKey = mR.findModule((module) => module.default && module.default.fromString)[0].default;
window.Store.SendMessage = mR.findModule('addAndSendMsgToChat').filter((m)=>m.addAndSendMsgToChat !== undefined)[0]

const _isMDBackend = mR.findModule('isMDBackend');
if(_isMDBackend && _isMDBackend[0] && _isMDBackend[0].isMDBackend) {
    window.Store.MDBackend = _isMDBackend[0].isMDBackend();
} else {
    window.Store.MDBackend = true;
}

document.userScripts.replyMsg = async function (chatId, msg) {
	const chatWid = window.Store.WidFactory.createWid(chatId);
	const chat = await window.Store.Chat.find(chatWid);
	const meUser = window.Store.User.getMaybeMeUser();
	const isMD = window.Store.MDBackend;
	const newId = await window.Store.MsgKey.newId();
	const newMsgId = new window.Store.MsgKey({
		from: meUser,
		to: chat.id,
		id: newId,
		participant: isMD && chat.id.isGroup() ? meUser : undefined,
		selfDir: 'out',
	});

	window.Store.SendMessage.addAndSendMsgToChat(chat, {
		id: newMsgId,
		ack: 0,
		body: msg, // Se cambia por el mensaje que replica
		from: meUser,
		to: chat.id,
		local: true,
		self: 'out',
		t: parseInt(new Date().getTime() / 1000),
		isNewMsg: true,
		type: 'chat',
	});
}
