import { useEffect, useRef, useState } from 'react';
import * as THREE from 'three';
import { STLLoader } from 'three/examples/jsm/loaders/STLLoader.js';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js';
import { supabase } from '../../lib/supabase';

interface STLViewerProps {
  modelName: string;
  width?: number;
  height?: number;
}

export function STLViewer({ modelName, width = 300, height = 300 }: STLViewerProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const sceneRef = useRef<THREE.Scene | null>(null);
  const cameraRef = useRef<THREE.PerspectiveCamera | null>(null);
  const rendererRef = useRef<THREE.WebGLRenderer | null>(null);
  const controlsRef = useRef<OrbitControls | null>(null);
  const frameIdRef = useRef<number>(0);
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    if (!containerRef.current || !modelName) {
      setIsLoading(false);
      return;
    }

    // Initialize scene
    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0xf8fafc); // Tailwind gray-50
    sceneRef.current = scene;

    // Initialize camera with wider FOV for better visibility
    const camera = new THREE.PerspectiveCamera(60, width / height, 0.1, 1000);
    camera.position.z = 100;
    cameraRef.current = camera;

    // Initialize renderer
    const renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setSize(width, height);
    renderer.setPixelRatio(window.devicePixelRatio);
    containerRef.current.appendChild(renderer.domElement);
    rendererRef.current = renderer;

    // Enhanced lighting setup
    const ambientLight = new THREE.AmbientLight(0x808080); // Brighter ambient light
    scene.add(ambientLight);

    const directionalLight1 = new THREE.DirectionalLight(0xffffff, 0.8);
    directionalLight1.position.set(1, 1, 1);
    scene.add(directionalLight1);

    const directionalLight2 = new THREE.DirectionalLight(0xffffff, 0.5);
    directionalLight2.position.set(-1, -1, -1);
    scene.add(directionalLight2);

    const pointLight = new THREE.PointLight(0xffffff, 0.8);
    pointLight.position.set(0, 50, 50);
    scene.add(pointLight);

    // Add controls
    const controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.dampingFactor = 0.05;
    controls.enableZoom = true;
    controlsRef.current = controls;

    // Load STL file
    const loadModel = async () => {
      try {
        setIsLoading(true);
        setError(null);
        
        const filename = modelName.toLowerCase().replace(/[^a-z0-9]+/g, '_') + '.stl';
        
        // First check if the file exists
        const { data: files, error: listError } = await supabase.storage
          .from('stl')
          .list('', {
            search: filename
          });

        if (listError) throw listError;
        
        // If file doesn't exist, show placeholder
        if (!files || files.length === 0) {
          setError('No 3D model available');
          setIsLoading(false);
          return;
        }

        const { data, error: downloadError } = await supabase.storage
          .from('stl')
          .download(filename);

        if (downloadError) throw downloadError;

        const loader = new STLLoader();
        const geometry = await new Promise<THREE.BufferGeometry>((resolve, reject) => {
          loader.load(
            URL.createObjectURL(data),
            resolve,
            undefined,
            reject
          );
        });

        const material = new THREE.MeshPhongMaterial({
          color: 0xcccccc, // Light grey color
          specular: 0x111111,
          shininess: 100,
          flatShading: false // Smooth shading
        });

        const mesh = new THREE.Mesh(geometry, material);

        // Center and scale the model
        geometry.computeBoundingBox();
        const boundingBox = geometry.boundingBox;
        if (boundingBox) {
          const center = new THREE.Vector3();
          boundingBox.getCenter(center);
          geometry.translate(-center.x, -center.y, -center.z);

          // Calculate size and adjust camera
          const size = new THREE.Vector3();
          boundingBox.getSize(size);
          const maxDim = Math.max(size.x, size.y, size.z);
          const fov = camera.fov * (Math.PI / 180);
          const cameraZ = Math.abs(maxDim / (2 * Math.tan(fov / 2))) * 1.2; // Add 20% margin
          camera.position.z = cameraZ;
          camera.updateProjectionMatrix();

          // Rotate for better initial view
          mesh.rotation.x = -Math.PI / 4;
          mesh.rotation.y = Math.PI / 4;
        }

        scene.add(mesh);
        setIsLoading(false);
      } catch (err) {
        console.error('Error loading or processing STL file:', err);
        setError('Unable to load 3D model');
        setIsLoading(false);
      }
    };

    if (modelName) {
      loadModel();
    }

    // Animation loop
    const animate = () => {
      frameIdRef.current = requestAnimationFrame(animate);
      controls.update();
      renderer.render(scene, camera);
    };
    animate();

    // Cleanup
    return () => {
      if (frameIdRef.current) {
        cancelAnimationFrame(frameIdRef.current);
      }
      if (rendererRef.current && containerRef.current) {
        containerRef.current.removeChild(rendererRef.current.domElement);
      }
      if (controlsRef.current) {
        controlsRef.current.dispose();
      }
    };
  }, [modelName, width, height]);

  if (isLoading) {
    return (
      <div 
        className="flex items-center justify-center bg-gray-50 rounded-lg"
        style={{ width, height }}
      >
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto mb-2"></div>
          <p className="text-sm text-gray-600">Loading model...</p>
        </div>
      </div>
    );
  }

  if (error || !modelName) {
    return (
      <div 
        className="flex items-center justify-center bg-gray-50 rounded-lg"
        style={{ width, height }}
      >
        <div className="text-center">
          <p className="text-sm font-medium text-gray-900">{modelName || 'No model selected'}</p>
          <p className="text-xs text-gray-500 mt-1">{error || 'No 3D model available'}</p>
        </div>
      </div>
    );
  }

  return (
    <div 
      ref={containerRef} 
      className="relative rounded-lg overflow-hidden shadow-lg"
      style={{ width, height }}
    />
  );
}