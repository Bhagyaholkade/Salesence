import { Router, type Router as RouterType } from 'express';
const router: RouterType = Router();

router.get('/', async (_req,res)=>{
  // Simple health check without database to avoid pgbouncer issues
  res.json({ok:true, ts:new Date().toISOString(), status:'healthy'}); 
});

export default router;
