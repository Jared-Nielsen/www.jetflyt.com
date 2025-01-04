import { Helmet } from 'react-helmet-async';

interface SEOProps {
  title: string;
  description?: string;
  keywords?: string[];
  image?: string;
  noindex?: boolean;
}

export function SEO({ 
  title, 
  description = 'Aviation fuel tender management system for streamlined procurement',
  keywords = ['aviation', 'fuel', 'tender', 'procurement', 'JetFlyt'],
  image = 'https://images.unsplash.com/photo-1464037866556-6812c9d1c72e',
  noindex = false 
}: SEOProps) {
  const siteTitle = `${title} | JetFlyt`;
  
  return (
    <Helmet>
      <title>{siteTitle}</title>
      <meta name="description" content={description} />
      <meta name="keywords" content={keywords.join(', ')} />
      
      {/* Open Graph */}
      <meta property="og:title" content={siteTitle} />
      <meta property="og:description" content={description} />
      <meta property="og:image" content={image} />
      <meta property="og:type" content="website" />
      
      {/* Twitter */}
      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:title" content={siteTitle} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={image} />
      
      {noindex && <meta name="robots" content="noindex,nofollow" />}
    </Helmet>
  );
}