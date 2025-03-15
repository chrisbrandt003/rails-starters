function loadJquery() {
  return new Promise((resolve, reject) => {
    const script = document.createElement('script');
    script.src = '/js/jquery.js'; // URL of the script
    script.onload = () => {
      console.log('Script loaded successfully');
      resolve();
    };
    script.onerror = () => {
      console.error('Failed to load script');
      reject(new Error('Failed to load script'));
    };
    document.head.appendChild(script);
  });
}

  const controller = {
    actions: {
      set: function(data) { 
        console.log('onString called');
        let target = $(`${data.target}`);
        target.text(data.value);
      },
      append: function(data) {
        $(`${data.target}`).append(data.value);
      },
      speak: function(data) {
        var msg = new SpeechSynthesisUtterance();
        msg.text = data.value;
        window.speechSynthesis.speak(msg);
      }
    }
  };

function loadReceiver() {
  const pathParts = window.location.pathname.split('/').filter(Boolean);
  const siteName = pathParts[1]; 

  // WS
  let identifier;
  const socket = new WebSocket(`ws://localhost:3000/cable`);
  socket.onopen = () => {
    console.log('Connected to WebSocket');

    // Send subscription request to the channel
    const msg = {
      command: 'subscribe',
      identifier: JSON.stringify({
        channel: 'SiteChannel',
        siteName: siteName
      })
    };

    socket.send(JSON.stringify(msg));
  };

  socket.onmessage = (event) => {
    const data = JSON.parse(event.data);

    if (data.type === 'ping') return;
    console.log(data)
    
    if(data.type === 'confirm_subscription') {
      identifier = JSON.parse(data.identifier);
      console.log(identifier)

      // const stream_id = {
      //   command: 'message',
      //   identifier: data.identifier,
      //   data: JSON.stringify({ action: "receive", content: "Hi everyone!" })
      // };

      // socket.send(JSON.stringify(stream_id));
    }

    if(data.message) {
      if (data.message.type === 'action') {
        console.log(data.message)
        controller.actions[data.message.function](data.message);
      }
    }
  };

  socket.onclose = () => {
    console.log('Disconnected from WebSocket');
  };

  socket.onerror = (error) => {
    console.error('WebSocket Error:', error);
  };
}

(async () => {
  await loadJquery();
  loadReceiver();
})();

