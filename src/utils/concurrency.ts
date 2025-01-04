import { useRef, useCallback } from 'react';

// Track in-flight operations
const operationsMap = new Map<string, Promise<any>>();

/**
 * Ensures only one instance of an async operation runs at a time
 * @param key Unique identifier for the operation
 * @param operation Async function to execute
 * @returns Result of the operation
 */
export async function runExclusive<T>(
  key: string, 
  operation: () => Promise<T>
): Promise<T> {
  const existing = operationsMap.get(key);
  if (existing) {
    return existing;
  }

  const promise = operation().finally(() => {
    operationsMap.delete(key);
  });
  
  operationsMap.set(key, promise);
  return promise;
}

/**
 * React hook for managing concurrent operations
 */
export function useConcurrentOperation() {
  const operationsRef = useRef(new Map<string, Promise<any>>());

  const runOperation = useCallback(async <T>(
    key: string,
    operation: () => Promise<T>
  ): Promise<T> => {
    const existing = operationsRef.current.get(key);
    if (existing) {
      return existing;
    }

    const promise = operation().finally(() => {
      operationsRef.current.delete(key);
    });

    operationsRef.current.set(key, promise);
    return promise;
  }, []);

  return { runOperation };
}