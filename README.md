# 🤖 AI-Powered Customer Support Bot System
### Rocket.Chat + n8n + Groq (Llama 3.3) + MariaDB

---

## 📋 Project Overview

This project is a **fully automated AI customer support system** built for the AKOIN Digital Risk Academy & Advisory platform. It integrates Rocket.Chat Omnichannel livechat with an n8n workflow automation engine and a Groq-powered AI agent (Llama 3.3 70B) to provide instant, intelligent responses to customer queries — 24/7, at zero per-message cost.

---

## 🏗️ System Architecture

```
Customer (Website Chat Widget)
        │
        ▼
 Rocket.Chat (Port 3000)       ← Livechat Interface
        │  Webhook Trigger
        ▼
   n8n Workflow (Port 5678)    ← Orchestration Engine
        │
        ├──► Extract User Data (JavaScript Node)
        │         │ Room ID + Message
        ▼
   AI Agent Node
        │
        ├──► Groq / Llama 3.3 (Language Model)
        ├──► Memory Buffer (Conversation History)
        └──► MariaDB MCP Tool (Order Lookups)
        │
        ▼
   Rocket.Chat API             ← Post reply back to chat
        │
        ▼
Customer receives AI response
```

---

## 🧰 Tech Stack

| Component       | Technology                  | Purpose                          |
|-----------------|-----------------------------|----------------------------------|
| Chat Interface  | Rocket.Chat (Omnichannel)   | Customer-facing livechat widget  |
| Orchestration   | n8n (self-hosted)           | Workflow automation & routing    |
| AI Brain        | Groq — Llama 3.3 70B        | Natural language understanding   |
| Database        | MariaDB                     | Order & customer data storage    |
| Infrastructure  | Docker Compose              | Container orchestration          |
| Frontend        | HTML / CSS / JavaScript     | AKOIN website with chat embed    |

---

## 📦 Prerequisites

- **Docker Desktop** installed and running
- **Node.js** v18+ (for local tools)
- **Python 3.x** (for local HTTP server)
- **Groq API Key** — free at [console.groq.com](https://console.groq.com)
- Ports **3000**, **5678**, **3306**, **27017** must be free

---

## 🚀 Installation & Setup

### 1. Clone / Navigate to the project directory
```bash
cd d:\antigrav\support_bot_system
```

### 2. Start all containers
```bash
docker compose up -d
```

This starts:
- `support_rocketchat` — Rocket.Chat on port 3000
- `support_n8n` — n8n on port 5678
- `support_mongo` — MongoDB (Rocket.Chat database)
- `support_mariadb` — MariaDB on port 3306

### 3. Verify all containers are running
```bash
docker ps
```

All 4 containers should show status **Up**.

### 4. Access the dashboards

| Service       | URL                        | Credentials                              |
|---------------|----------------------------|------------------------------------------|
| Rocket.Chat   | http://localhost:3000      | kesakkiramya@gmail.com / (admin password)|
| n8n Dashboard | http://localhost:5678      | admin / (n8n password)                   |
| AKOIN Website | http://localhost:8080      | Open `index.html` via Python server      |

### 5. Start the local website server
```bash
cd d:\antigrav
python -m http.server 8080
```
Then open **http://localhost:8080** in your browser.

---

## ⚙️ Configuration

### docker-compose.yml (Key Settings)
```yaml
n8n:
  environment:
    - NODE_TLS_REJECT_UNAUTHORIZED=0    # Bypass SSL for local dev
    - N8N_HOST=0.0.0.0
  dns:
    - 8.8.8.8                           # Google DNS for AI API access
    - 8.8.4.4
```

### Groq AI Credential (in n8n)
- **Provider:** Groq
- **Model:** `llama-3.3-70b-versatile`
- **API Key:** Stored securely in n8n credentials manager

### Rocket.Chat Livechat Widget (in index.html)
```javascript
(function(w, d, s, u) {
    w.RocketChat = function(c) { w.RocketChat._.push(c) };
    w.RocketChat._ = [];
    w.RocketChat.url = u;
    var h = d.getElementsByTagName(s)[0], j = d.createElement(s);
    j.async = true;
    j.src = 'http://localhost:3000/livechat/rocketchat-livechat.min.js';
    h.parentNode.insertBefore(j, h);
})(window, document, 'script', 'http://localhost:3000/livechat');

RocketChat(function() {
    this.setTheme({
        color: '#FF6600',          // AKOIN brand orange
        title: 'Chat with AKOIN',
        onlineTitle: "We're Online!"
    });
});
```

---

## 🔄 How It Works — Message Flow

1. **Customer** types a message in the chat widget on the AKOIN website.
2. **Rocket.Chat** receives the message and fires a **webhook** to n8n.
3. **n8n** receives the webhook and runs the workflow:
   - **Extract Node:** Pulls out the `message text` and `room ID` from the webhook payload.
   - **AI Agent Node:** Sends the message to Groq (Llama 3.3) with conversation memory.
   - **Groq AI:** Generates an intelligent, context-aware response.
   - *(Optional)* **MariaDB Tool:** Queries order/customer data if needed.
4. **n8n** posts the AI response back to Rocket.Chat via the **Rocket.Chat API**.
5. **Customer** sees the reply appear in the chat window within 2–5 seconds.

---

## 🌐 Livechat Widget Embed

To add the chat bubble to **any HTML page**, add this code before `</body>`:

```html
<script type="text/javascript">
(function(w, d, s, u) {
    w.RocketChat = function(c) { w.RocketChat._.push(c) };
    w.RocketChat._ = []; w.RocketChat.url = u;
    var h = d.getElementsByTagName(s)[0], j = d.createElement(s);
    j.async = true;
    j.src = 'http://YOUR_SERVER_IP:3000/livechat/rocketchat-livechat.min.js';
    h.parentNode.insertBefore(j, h);
})(window, document, 'script', 'http://YOUR_SERVER_IP:3000/livechat');
RocketChat(function() {
    this.setTheme({ color: '#FF6600', title: 'Chat with AKOIN' });
});
</script>
```

> Replace `YOUR_SERVER_IP` with your actual server IP or domain when deploying to production.

---

## 🛠️ Troubleshooting

| Problem | Cause | Fix |
|---|---|---|
| Bot not replying | Groq API quota exceeded | Wait 24h or use a new API key |
| Chat widget not appearing | Page opened as `file://` | Serve via `python -m http.server 8080` |
| n8n can't reach Rocket.Chat | IP changed after restart | Use container name `http://support_rocketchat:3000` |
| Containers down after sleep | Docker stopped | Run `docker compose up -d` |
| 401 Unauthorized error | Expired API token | Regenerate Personal Access Token in Rocket.Chat |

---

## 📊 n8n Workflow Monitoring

- Open **http://localhost:5678**
- Click **Executions** (left sidebar)
- Every customer message creates one execution
  - 🟢 **Green** = Message received and replied successfully
  - 🔴 **Red** = Error occurred — click to see details

---

## 🗺️ Next Steps / Roadmap

- [ ] **Production Deployment** — Deploy to a cloud server (e.g., AWS EC2, DigitalOcean) with a real domain
- [ ] **WordPress Integration** — Embed the widget on a live WordPress site
- [ ] **MariaDB Tool** — Reconnect the database query tool for live order status lookups
- [ ] **Multi-department Routing** — Route chats to different departments based on topic
- [ ] **Analytics Dashboard** — Track chat volume, response times, and satisfaction scores

---

## 👩‍💻 Author

**Esakki Ramya K**  
AKOIN Digital Risk Academy & Advisory  
kesakkiramya@gmail.com

---

## 📄 License

This project is proprietary and confidential. All rights reserved © 2026 AKOIN Digital Risk.
