interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
}

export function Modal({ isOpen, onClose, title, children }: ModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-[9999] overflow-y-auto">
      <div className="flex min-h-screen items-center justify-center px-4">
        {/* Backdrop - removed onClick handler */}
        <div className="fixed inset-0 bg-black bg-opacity-30" />
        
        <div className="relative bg-white rounded-lg shadow-xl max-w-lg w-full">
          <div className="px-6 py-4 border-b">
            <h2 className="text-xl font-semibold text-gray-900">{title}</h2>
          </div>
          
          <div className="p-6">
            {children}
          </div>
        </div>
      </div>
    </div>
  );
}