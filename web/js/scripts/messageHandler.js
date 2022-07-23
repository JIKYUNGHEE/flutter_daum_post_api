var postData;

function setPostData(data) {
    postData = data;
}

function postMessage() {
    return JSON.stringify(postData)
}