import { Router, type Router as RouterType } from 'express';
import { db } from '@scraper/db';
const router: RouterType = Router();

router.get('/', async (_req,res)=>{
  try{ 
    // Use $executeRawUnsafe instead of $queryRaw to avoid prepared statement issues with pgbouncer
    await db.$executeRawUnsafe('SELECT 1'); 
    res.json({ok:true, ts:new Date().toISOString(), db:'up'}); 
  }
  catch(_e){ 
    res.status(503).json({ok:false, db:'down'}); 
  }
});

export default router;
