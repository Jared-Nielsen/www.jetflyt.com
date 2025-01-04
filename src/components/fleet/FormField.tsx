interface FormFieldProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label: string;
}

export function FormField({ label, ...props }: FormFieldProps) {
  return (
    <div>
      <label className="block text-sm font-medium text-gray-700 mb-1">
        {label}
      </label>
      <input
        className="block w-full px-4 py-3 rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 text-base"
        {...props}
      />
    </div>
  );
}