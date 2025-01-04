import { SEO } from '../../components/SEO';

export default function TermsConditions() {
  return (
    <>
      <SEO 
        title="Terms & Conditions"
        description="JetFlyt's terms of service and usage conditions."
      />
      <div className="max-w-4xl mx-auto px-4 py-12">
        <h1 className="text-3xl font-bold mb-8">Terms & Conditions</h1>
        
        <div className="prose max-w-none">
          <p className="lead">Last updated: {new Date().toLocaleDateString()}</p>
          
          <h2>1. Acceptance of Terms</h2>
          <p>By accessing and using JetFlyt's services, you agree to be bound by these Terms & Conditions.</p>

          <h2>2. Service Description</h2>
          <p>JetFlyt provides an aviation fuel tender management platform that enables:</p>
          <ul>
            <li>Submission of fuel tender offers</li>
            <li>Fleet management</li>
            <li>FBO location services</li>
          </ul>

          {/* Additional sections... */}
        </div>
      </div>
    </>
  );
}