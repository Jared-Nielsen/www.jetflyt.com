import { SEO } from '../../components/SEO';

export default function PrivacyPolicy() {
  return (
    <>
      <SEO 
        title="Privacy Policy"
        description="JetFlyt's privacy policy and data protection practices."
      />
      <div className="max-w-4xl mx-auto px-4 py-12">
        <h1 className="text-3xl font-bold mb-8">Privacy Policy</h1>
        
        <div className="prose max-w-none">
          <p className="lead">Last updated: {new Date().toLocaleDateString()}</p>
          
          <h2>1. Information We Collect</h2>
          <p>We collect information that you provide directly to us, including:</p>
          <ul>
            <li>Name and contact information</li>
            <li>Company details</li>
            <li>Aircraft fleet information</li>
            <li>Fuel tender specifications</li>
          </ul>

          <h2>2. How We Use Your Information</h2>
          <p>We use the information we collect to:</p>
          <ul>
            <li>Provide and maintain our services</li>
            <li>Process your fuel tender submissions</li>
            <li>Send you important service updates</li>
            <li>Improve our platform</li>
          </ul>

          {/* Additional sections... */}
        </div>
      </div>
    </>
  );
}