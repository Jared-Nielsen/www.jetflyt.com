import React from 'react';
import { useTranslation } from 'react-i18next';
import type { Tender } from '../../types/tender';

interface TenderStatusProps {
  status: Tender['status'];
}

export function TenderStatus({ status }: TenderStatusProps) {
  const { t } = useTranslation();

  const statusStyles = {
    pending: 'bg-yellow-100 text-yellow-800',
    active: 'bg-blue-100 text-blue-800',
    accepted: 'bg-green-100 text-green-800',
    rejected: 'bg-red-100 text-red-800'
  };

  return (
    <span className={`inline-block px-2 py-1 text-sm rounded-full ${statusStyles[status]}`}>
      {t(`tenders.status.${status}`)}
    </span>
  );
}