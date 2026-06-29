// Supabase Edge Function: invia email all'admin quando arriva una nuova
// richiesta falesia (insert su crag_requests).
//
// Attivazione (DOPO aver configurato Gmail):
//   1. Crea una "app password" Google (account con 2FA): https://myaccount.google.com/apppasswords
//   2. supabase secrets set GMAIL_USER=flavioaugusto.difoggia@gmail.com
//      supabase secrets set GMAIL_APP_PASSWORD=xxxxxxxxxxxxxxxx
//      supabase secrets set NOTIFY_TO=flavioaugusto.difoggia@gmail.com
//   3. supabase functions deploy notify-crag-request
//   4. Crea un Database Webhook (Dashboard → Database → Webhooks) su
//      INSERT di public.crag_requests che POSTa a questa funzione.
//
// Finché non è attivata, le richieste restano comunque visibili in /admin/requests.

import { SMTPClient } from 'https://deno.land/x/denomailer@1.6.0/mod.ts'

interface CragRequestRecord {
  crag_name: string
  sector_name: string | null
  route_name: string
  raw_grade: string | null
  count: number
}

Deno.serve(async (req) => {
  try {
    const body = await req.json()
    // payload webhook Supabase: { type, table, record, ... }
    const rec: CragRequestRecord = body.record ?? body

    const user = Deno.env.get('GMAIL_USER')
    const pass = Deno.env.get('GMAIL_APP_PASSWORD')
    const to = Deno.env.get('NOTIFY_TO') ?? user
    if (!user || !pass) {
      return new Response('SMTP non configurato (GMAIL_USER/GMAIL_APP_PASSWORD mancanti)', { status: 500 })
    }

    const client = new SMTPClient({
      connection: { hostname: 'smtp.gmail.com', port: 465, tls: true, auth: { username: user, password: pass } },
    })

    await client.send({
      from: user,
      to,
      subject: `Capital Climbing — falesia mancante: ${rec.crag_name}`,
      content: [
        `Nuova richiesta falesia dall'import logbook.`,
        ``,
        `Falesia: ${rec.crag_name}`,
        `Settore: ${rec.sector_name ?? '—'}`,
        `Via: ${rec.route_name}`,
        `Grado: ${rec.raw_grade ?? '—'}`,
        `Ascensioni in coda: ${rec.count}`,
        ``,
        `Aggiungi la via al catalogo: verranno importate automaticamente.`,
        `Pannello: /admin/requests`,
      ].join('\n'),
    })
    await client.close()

    return new Response('ok', { status: 200 })
  } catch (e) {
    return new Response(`errore: ${(e as Error).message}`, { status: 500 })
  }
})
