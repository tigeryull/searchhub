export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const key = url.pathname.replace('/', '');
    
    if (request.method === 'GET') {
      const count = await env.COUNT.get(key) || '0';
      return new Response(count, {
        headers: { 
          'content-type': 'text/plain',
          'access-control-allow-origin': '*'
        }
      });
    }
    
    if (request.method === 'POST') {
      let count = parseInt(await env.COUNT.get(key) || '0', 10);
      count++;
      await env.COUNT.put(key, count.toString(), { expirationTtl: 60 * 60 * 24 * 365 });
      return new Response(count.toString(), {
        headers: { 
          'content-type': 'text/plain',
          'access-control-allow-origin': '*'
        }
      });
    }
    
    return new Response('OK', { status: 200 });
  }
}
