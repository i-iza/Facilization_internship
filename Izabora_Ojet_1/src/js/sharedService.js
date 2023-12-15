define([], function () {
    const subscribers = {};
  
    function publish(event, data) {
      if (subscribers[event]) {
        subscribers[event].forEach(callback => callback(data));
      }
    }
  
    function subscribe(event, callback) {
      if (!subscribers[event]) {
        subscribers[event] = [];
      }
      subscribers[event].push(callback);
    }
  
    return {
      publish,
      subscribe,
    };
  });
  