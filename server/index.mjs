import { createServer } from 'node:http';
import { pathToFileURL } from 'node:url';

import { ApiError, createFinanceAssistant } from './ai.mjs';

function allowedOrigin(origin, allowedOrigins) {
  if (!origin) return true;
  try {
    const url = new URL(origin);
    return allowedOrigins.includes(origin)
      || (url.protocol === 'http:' && ['localhost', '127.0.0.1', '[::1]'].includes(url.hostname));
  } catch { return false; }
}

async function readBody(request) {
  let length = 0;
  const chunks = [];
  for await (const chunk of request) {
    length += chunk.length;
    if (length > 6 * 1024 * 1024) throw new ApiError(413, 'Permintaan terlalu besar.');
    chunks.push(chunk);
  }
  try { return JSON.parse(Buffer.concat(chunks).toString('utf8')); }
  catch { throw new ApiError(400, 'JSON tidak valid.'); }
}

export function createApp({
  answer = createFinanceAssistant({
    apiKey: process.env.GEMINI_API_KEY,
    model: process.env.GEMINI_MODEL || 'gemini-3.5-flash-lite',
  }),
  allowedOrigins = (process.env.ALLOWED_ORIGINS || '').split(',').map(value => value.trim()),
} = {}) {
  const clients = new Map();
  const server = createServer(async (request, response) => {
    const origin = request.headers.origin;
    response.setHeader('Content-Type', 'application/json; charset=utf-8');
    response.setHeader('Cache-Control', 'no-store');
    response.setHeader('X-Content-Type-Options', 'nosniff');
    response.setHeader('Vary', 'Origin');
    const send = (status, body) => {
      response.writeHead(status);
      response.end(JSON.stringify(body));
    };
    if (!allowedOrigin(origin, allowedOrigins)) return send(403, { error: 'Origin tidak diizinkan.' });
    if (origin) response.setHeader('Access-Control-Allow-Origin', origin);
    response.setHeader('Access-Control-Allow-Headers', 'Content-Type');
    response.setHeader('Access-Control-Allow-Methods', 'POST, GET, OPTIONS');
    if (request.method === 'OPTIONS') { response.writeHead(204); response.end(); return; }
    if (request.url === '/health' && request.method === 'GET') return send(200, { status: 'ok' });
    if (request.url !== '/api/chat') return send(404, { error: 'Endpoint tidak ditemukan.' });
    if (request.method !== 'POST') return send(405, { error: 'Gunakan POST.' });
    const contentType = request.headers['content-type']?.split(';')[0].trim().toLowerCase();
    if (contentType !== 'application/json') {
      return send(415, { error: 'Gunakan Content-Type application/json.' });
    }
    const now = Date.now();
    for (const [key, entry] of clients) {
      if (entry.resetAt < now && entry.active === 0) clients.delete(key);
    }
    const ip = request.socket.remoteAddress;
    const client = clients.get(ip) ?? { count: 0, active: 0, resetAt: now + 60000 };
    if (client.resetAt < now) { client.count = 0; client.resetAt = now + 60000; }
    clients.set(ip, client);
    if (client.count >= 20 || client.active >= 2) {
      response.setHeader('Retry-After', '60');
      return send(429, { error: 'Terlalu banyak permintaan. Tunggu sebentar lalu coba lagi.' });
    }
    client.count++;
    client.active++;
    try {
      send(200, await answer(await readBody(request)));
    } catch (error) {
      send(error instanceof ApiError ? error.status : 500, {
        error: error instanceof ApiError ? error.message : 'Layanan AI sedang bermasalah.',
      });
    } finally { client.active--; }
  });
  server.requestTimeout = 110000;
  server.headersTimeout = 15000;
  return server;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const port = Number(process.env.PORT || 8080);
  const host = process.env.HOST || '127.0.0.1';
  createApp().listen(port, host, () => {
    console.log(`SiFinance AI berjalan di http://${host}:${port}`);
  });
}
