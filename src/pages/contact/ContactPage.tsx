import { useState } from 'react';
import { SEO } from '../../components/SEO';
import { supabase } from '../../lib/supabase';

export default function ContactPage() {
  const [formData, setFormData] = useState({
    email: '',
    phone: '',
    message: ''
  });
  const [status, setStatus] = useState<'idle' | 'submitting' | 'success' | 'error'>('idle');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setStatus('submitting');

    try {
      const { error } = await supabase
        .from('contact_messages')
        .insert([{
          email: formData.email,
          phone: formData.phone,
          message: formData.message
        }]);

      if (error) throw error;
      
      setStatus('success');
      setFormData({ email: '', phone: '', message: '' });
    } catch (error) {
      console.error('Error submitting contact form:', error);
      setStatus('error');
    }
  };

  return (
    <>
      <SEO 
        title="Contact Us"
        description="Get in touch with JetFlyt's support team."
      />
      <div className="max-w-2xl mx-auto px-4 py-12">
        <h1 className="text-3xl font-bold mb-8">Contact Us</h1>

        {status === 'success' ? (
          <div className="bg-green-50 border-l-4 border-green-400 p-4 mb-8">
            <p className="text-green-700">
              Thank you for your message. We'll get back to you soon!
            </p>
          </div>
        ) : status === 'error' ? (
          <div className="bg-red-50 border-l-4 border-red-400 p-4 mb-8">
            <p className="text-red-700">
              There was an error sending your message. Please try again.
            </p>
          </div>
        ) : null}
        
        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <label htmlFor="email" className="block text-sm font-medium text-gray-700">
              Email Address
            </label>
            <input
              type="email"
              id="email"
              required
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
              value={formData.email}
              onChange={(e) => setFormData(prev => ({ ...prev, email: e.target.value }))}
            />
          </div>

          <div>
            <label htmlFor="phone" className="block text-sm font-medium text-gray-700">
              Phone Number
            </label>
            <input
              type="tel"
              id="phone"
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
              value={formData.phone}
              onChange={(e) => setFormData(prev => ({ ...prev, phone: e.target.value }))}
            />
          </div>

          <div>
            <label htmlFor="message" className="block text-sm font-medium text-gray-700">
              Message
            </label>
            <textarea
              id="message"
              rows={4}
              required
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
              value={formData.message}
              onChange={(e) => setFormData(prev => ({ ...prev, message: e.target.value }))}
            />
          </div>

          <button
            type="submit"
            disabled={status === 'submitting'}
            className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50"
          >
            {status === 'submitting' ? 'Sending...' : 'Send Message'}
          </button>
        </form>
      </div>
    </>
  );
}