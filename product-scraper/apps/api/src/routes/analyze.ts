import { Router, type Router as RouterType } from 'express';
import { z } from 'zod';
import { createLogger } from '../lib/logger';
import { scrapeProduct, searchAndRecommend } from '@scraper/scraper-core';
import { AnalyzeResponse } from '../lib/responseTypes';

const router: RouterType = Router();
const schema = z.object({ url: z.string().url() });
const log = createLogger('analyze');

router.post('/', async (req,res,next)=>{
  const started = Date.now();
  try{
    const parsed = schema.parse(req.body);
    log.info({url: parsed.url}, 'Starting scrape');
    
    const r1 = await scrapeProduct(parsed.url, 'req-'+started);
    log.info({product: r1.product.name}, 'Scrape complete');
    
    const recs = await searchAndRecommend(r1.product, r1.marketplace, 'req-'+started, parsed.url);
    log.info({recsCount: recs.length}, 'Recommendations complete');

    const response: AnalyzeResponse = {
      productDetails: {
        name: r1.product.name,
        price: { amount: Number(r1.product.priceAmount), currency: r1.product.priceCurrency },
        rating: { value: Number(r1.product.ratingValue||0), count: r1.product.ratingCount||0 },
        images: r1.product.images as string[],
        categoryPath: r1.product.categoryPath
      },
      recommendations: recs.map(x=> ({
        name: x.name,
        price: { amount: Number(x.priceAmount), currency: x.priceCurrency },
        rating: { value: Number(x.ratingValue), count: x.ratingCount||0 },
        image: x.imageUrl,
        productUrl: x.recommendedProductUrl
      })),
      meta: { marketplace: r1.marketplace, scrapingMode: r1.scrapingMode, tookMs: Date.now()-started }
    };
    log.info({tookMs: response.meta.tookMs, recs: response.recommendations.length}, 'done');
    res.json(response);
  }catch(e){ 
    log.error({error: e, message: e instanceof Error ? e.message : 'Unknown error', stack: e instanceof Error ? e.stack : undefined}, 'Analyze failed');
    next(e); 
  }
});

export default router;
