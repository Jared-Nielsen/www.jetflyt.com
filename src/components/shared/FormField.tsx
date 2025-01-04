interface FormFieldProps extends React.InputHTMLAttributes<HTMLInputElement | HTMLTextAreaElement> {
  label: string;
  type?: 'text' | 'number' | 'date' | 'datetime-local' | 'textarea';
}

export function FormField({ label, type = 'text', ...props }: FormFieldProps) {
  const baseClasses = "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500";
  const inputClasses = `${baseClasses} px-4 py-2`;
  const textareaClasses = `${baseClasses} px-4 py-3`;
  
  return (
    <div className="mb-4">
      <label className="block text-sm font-medium text-gray-700 mb-1">
        {label}
      </label>
      {type === 'textarea' ? (
        <textarea
          className={textareaClasses}
          rows={3}
          {...props}
        />
      ) : (
        <input
          type={type}
          className={inputClasses}
          {...props}
        />
      )}
    </div>
  );
}