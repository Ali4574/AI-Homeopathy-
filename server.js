// server.js
// Simple Express proxy for OpenAI Chat Completions.
// Run with: node server.js (with .env file)
import express from "express";
import fetch from "node-fetch";
import cors from "cors";
import path from "path";
import { fileURLToPath } from "url";
import dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
app.use(cors());
app.use(express.json());

// Serve static files (HTML, CSS, JS)
app.use(express.static(__dirname));

// Get API key from environment variable (more secure)
const OPENAI_KEY = process.env.OPENAI_API_KEY;
if (!OPENAI_KEY) {
    console.error("ERROR: Set OPENAI_API_KEY environment variable in .env file");
    console.error("Example: OPENAI_API_KEY=sk-...");
    process.exit(1);
}

app.post("/api/chat", async (req, res) => {
    try {
        const { messages, temperature = 0.6 } = req.body;

        // Basic validation
        if (!Array.isArray(messages)) {
            return res.status(400).json({ error: "messages (array) is required in body." });
        }

        // Call OpenAI Chat Completions
        const payload = {
            model: "gpt-4o-mini", // change model if needed
            messages,
            temperature,
            max_tokens: 500
        };

        const r = await fetch("https://api.openai.com/v1/chat/completions", {
            method: "POST",
            headers: {
                "Authorization": `Bearer ${OPENAI_KEY}`,
                "Content-Type": "application/json"
            },
            body: JSON.stringify(payload)
        });

        if (!r.ok) {
            const errText = await r.text();
            console.error("OpenAI error:", r.status, errText);
            return res.status(500).json({ error: "OpenAI request failed", detail: errText });
        }

        const data = await r.json();
        // return the model's reply
        return res.json(data);
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: String(err) });
    }
});

// Serve the main HTML file
app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "index.html"));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server listening on http://localhost:${PORT}`);
    console.log(`Open your browser and go to: http://localhost:${PORT}`);
});
