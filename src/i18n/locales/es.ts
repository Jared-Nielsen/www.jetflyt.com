export const es = {
  translation: {
    // Navigation
    'nav.tenders': 'Licitaciones',
    'nav.handling': 'Handling',
    'nav.fleet': 'Flota',
    'nav.reports': 'Informes',
    'nav.signIn': 'Iniciar Sesión',
    'nav.signOut': 'Cerrar Sesión',

    // Landing Page
    'landing.title': 'Gestión de Licitaciones de Combustible y Handling',
    'landing.subtitle': 'Optimice su proceso de adquisición de combustible de aviación',
    'landing.auth.signInCta': 'Inicie sesión para acceder →',
    
    'landing.features.tenders.title': 'Enviar Licitación',
    'landing.features.tenders.description': 'Cree y envíe sus ofertas de contrato anual de combustible fácilmente.',
    
    'landing.features.handling.title': 'Handling',
    'landing.features.handling.description': 'Envíe una licitación para servicios de handling.',
    
    'landing.features.fleet.title': 'Gestión de Flota',
    'landing.features.fleet.description': 'Registre y gestione la información de su flota de aeronaves.',
    
    'landing.features.reports.title': 'Informes',
    'landing.features.reports.description': 'Visualice análisis e información sobre sus operaciones.',

    // Tender Management
    'tenders.title': 'Licitaciones',
    'tenders.subtitle': 'Cree y gestione sus licitaciones de combustible en varios FBOs.',
    'tenders.newTender': 'Nueva Licitación',
    
    'tenders.status.title': 'Estado',
    'tenders.status.pending': 'Pendiente',
    'tenders.status.active': 'Activo',
    'tenders.status.accepted': 'Aceptado',
    'tenders.status.rejected': 'Rechazado',
    'tenders.status.cancelled': 'Cancelado',

    'tenders.details.title': 'Detalles de la Licitación',
    'tenders.details.created': 'Creado el',
    'tenders.details.aircraft': 'Aeronave',
    'tenders.details.location': 'Ubicación',
    'tenders.details.fuelRequest': 'Solicitud de Combustible',
    'tenders.details.bestPrice': 'Mejor Precio Actual',
    'tenders.details.fboResponses': 'Respuestas de FBOs',
    'tenders.details.description': 'Descripción',
    'tenders.details.totalValue': 'Valor Total',
    'tenders.details.tenderId': 'ID de Licitación',

    'tenders.offers.columns.fbo': 'FBO',
    'tenders.offers.columns.location': 'Ubicación',
    'tenders.offers.columns.offerPrice': 'Precio Ofertado',
    'tenders.offers.columns.totalCost': 'Costo Total',
    'tenders.offers.columns.taxesAndFees': 'Impuestos y Tasas',
    'tenders.offers.columns.finalCost': 'Costo Final',
    'tenders.offers.columns.actions': 'Acciones',

    'tenders.offers.buttons.accept': 'Aceptar',
    'tenders.offers.buttons.sendContract': 'Enviar Contrato',
    'tenders.offers.buttons.close': 'Cerrar',
    'tenders.offers.buttons.cancel': 'Cancelar',
    'tenders.offers.status.canceled': 'Cancelado',

    'tenders.offers.modal.contractTitle': 'Confirmación del Contrato',
    'tenders.offers.modal.contractSent': 'El Contrato ha sido enviado a {{fbo}}',

    'tenders.offers.errors.acceptFailed': 'Error al aceptar la oferta. Por favor intente nuevamente.',

    'tenders.offers.noResponses': 'No se encontraron ofertas de licitación.',
    'tenders.offers.response': 'respuesta',
    'tenders.offers.responses': 'respuestas',

    'tenders.form.title.new': 'Crear Nueva Licitación',
    'tenders.form.title.edit': 'Editar Licitación',
    'tenders.form.title.cancel': 'Cancelar Licitación',

    'tenders.form.fields.aircraft': 'Aeronave',
    'tenders.form.fields.selectAircraft': 'Seleccione la aeronave',
    'tenders.form.fields.airport': 'Aeropuerto',
    'tenders.form.fields.selectAirport': 'Seleccione el aeropuerto',
    'tenders.form.fields.gallons': 'Galones Necesarios',
    'tenders.form.fields.targetPrice': 'Mejor Precio Actual',
    'tenders.form.fields.annual': 'Anual',
    'tenders.form.fields.startDate': 'Fecha de Inicio',
    'tenders.form.fields.endDate': 'Fecha de Término (Opcional)',
    'tenders.form.fields.description': 'Descripción',
    'tenders.form.fields.selectFbos': 'Seleccione los FBOs para Enviar Licitación',

    'tenders.form.buttons.cancel': 'Cancelar',
    'tenders.form.buttons.create': 'Crear Licitación',
    'tenders.form.buttons.update': 'Actualizar Licitación',
    'tenders.form.buttons.creating': 'Creando...',
    'tenders.form.buttons.edit': 'Editar',
    'tenders.form.buttons.cancelTender': 'Cancelar Licitación',
    'tenders.form.buttons.close': 'Cerrar',
    'tenders.form.buttons.keepIt': 'No, Mantener',
    'tenders.form.buttons.cancelling': 'Cancelando...',
    'tenders.form.buttons.confirmCancel': 'Sí, Cancelar Licitación',

    'tenders.form.confirmCancel': '¿Está seguro de que desea cancelar esta licitación? Esta acción no se puede deshacer.',

    'tenders.form.errors.invalidDates': 'La fecha de término debe ser posterior a la fecha de inicio',
    'tenders.form.errors.noFboSelected': 'Por favor seleccione al menos un FBO',

    // Ground Handling
    'handling.title': 'Servicios de Handling',
    'handling.subtitle': 'Cree y gestione sus solicitudes de servicios de handling.',
    'handling.newServiceTender': 'Nueva Licitación de Servicio',
    'handling.noServiceTenders': 'No se encontraron licitaciones de servicio.',

    'handling.details.title': 'Detalles de la Licitación de Servicio',
    'handling.details.created': 'Creado',
    'handling.details.arrival': 'Llegada',
    'handling.details.departure': 'Salida',
    'handling.details.service': 'Servicio',
    'handling.details.quantity': 'Cantidad',
    'handling.details.requestedDate': 'Fecha Solicitada',
    'handling.details.completedDate': 'Fecha de Finalización',
    'handling.details.description': 'Descripción',
    'handling.details.passengerInfo': 'Información de Pasajeros',
    'handling.details.passengers': 'Pasajeros',
    'handling.details.crew': 'Tripulación',
    'handling.details.pets': 'Mascotas',

    'handling.list.columns.aircraft': 'Aeronave',
    'handling.list.columns.service': 'Servicio',
    'handling.list.columns.fboLocations': 'Ubicaciones FBO',
    'handling.list.columns.description': 'Descripción',
    'handling.list.columns.status': 'Estado',
    'handling.list.fboLocations': 'Ubicaciones FBO',
    'handling.list.fboCount_one': 'FBO',
    'handling.list.fboCount_other': 'FBOs',

    'handling.status.pending': 'Pendiente',
    'handling.status.accepted': 'Aceptado',
    'handling.status.inProgress': 'En Proceso',
    'handling.status.completed': 'Completado',
    'handling.status.cancelled': 'Cancelado',

    'handling.form.title.new': 'Crear Nueva Licitación de Servicio',
    'handling.form.title.edit': 'Editar Licitación de Servicio',

    'handling.form.fields.aircraft': 'Aeronave',
    'handling.form.fields.selectAircraft': 'Seleccione la aeronave',
    'handling.form.fields.airport': 'Aeropuerto',
    'handling.form.fields.selectAirport': 'Seleccione el aeropuerto',
    'handling.form.fields.service': 'Servicio',
    'handling.form.fields.selectService': 'Seleccione el servicio',
    'handling.form.fields.quantity': 'Cantidad',
    'handling.form.fields.description': 'Descripción',
    'handling.form.fields.requestedDate': 'Fecha Solicitada',
    'handling.form.fields.arrivalDate': 'Fecha de Llegada (Opcional)',
    'handling.form.fields.departureDate': 'Fecha de Salida (Opcional)',
    'handling.form.fields.selectFbos': 'Seleccione los FBOs',
    'handling.form.fields.passengerCount': 'Número de Pasajeros',
    'handling.form.fields.crewCount': 'Número de Tripulantes',
    'handling.form.fields.petCount': 'Número de Mascotas',

    'handling.form.buttons.cancel': 'Cancelar',
    'handling.form.buttons.create': 'Crear Licitación',
    'handling.form.buttons.update': 'Actualizar Licitación',
    'handling.form.buttons.edit': 'Editar',
    'handling.form.buttons.cancelTender': 'Cancelar Licitación',
    'handling.form.errors.invalidDates': 'La fecha de salida debe ser posterior a la fecha de llegada',
    'handling.form.errors.noFboSelected': 'Por favor seleccione al menos un FBO',
    'handling.form.errors.noRequestedDate': 'La fecha solicitada es requerida',
    'handling.form.errors.submissionFailed': 'Error al enviar el formulario. Por favor intente nuevamente.',

    // Footer
    'footer.about.title': 'Acerca de JetFlyt',
    'footer.about.description': 'Optimizando la adquisición de combustible de aviación con soluciones innovadoras de gestión de licitaciones.',
    'footer.quickLinks.title': 'Enlaces Rápidos',
    'footer.quickLinks.fboMap': 'Mapa de FBOs',
    'footer.quickLinks.airports': 'Aeropuertos',
    'footer.quickLinks.dispatch': 'Despacho',
    'footer.quickLinks.support': 'Soporte',
    'footer.legal.title': 'Legal',
    'footer.legal.privacy': 'Política de Privacidad',
    'footer.legal.terms': 'Términos y Condiciones',
    'footer.contact.title': 'Contacto',
    'footer.contact.contactUs': 'Contáctenos',
    'footer.copyright': ' JetFlyt. Todos los derechos reservados.',

    // Fleet Management
    'fleet.title': 'Flota de Aeronaves',
    'fleet.subtitle': 'Gestione la información y especificaciones de su flota de aeronaves.',
    'fleet.addAircraft': 'Agregar Aeronave',
    'fleet.uploadExcel': 'Subir Excel',
    'fleet.downloadTemplate': 'Descargar Plantilla',
    'fleet.confirmDelete': '¿Está seguro de que desea eliminar esta aeronave?',
    'fleet.uploadSuccess': 'Datos de aeronave cargados exitosamente',
    'fleet.errors.saveFailed': 'Error al guardar la aeronave. Por favor, intente nuevamente.',
    'fleet.errors.deleteFailed': 'Error al eliminar la aeronave. Por favor, intente nuevamente.',
    'fleet.errors.uploadFailed': 'Error al cargar los datos. Verifique el formato e intente nuevamente.',

    // Aircraft Details
    'fleet.details.title': 'Detalles de la Aeronave',
    'fleet.details.registration': 'Matrícula',
    'fleet.details.edit': 'Editar',
    'fleet.details.viewOnMap': 'Ver en Mapa',
    'fleet.details.aircraftType': 'Tipo de Aeronave',
    'fleet.details.manufacturer': 'Fabricante',
    'fleet.details.year': 'Año',
    'fleet.details.engineType': 'Tipo de Motor',
    'fleet.details.fuelType': 'Tipo de Combustible',
    'fleet.details.fuelCapacity': 'Capacidad de Combustible',
    'fleet.details.maxRange': 'Alcance Máximo',
    'fleet.details.currentLocation': 'Ubicación Actual',
    'fleet.details.locationNotSet': 'Ubicación no establecida',
    'fleet.details.modelPreview': 'Vista Previa del Modelo 3D',

    'fleet.form.add': 'Agregar Nueva Aeronave',
    'fleet.form.edit': 'Editar Aeronave',
    'fleet.form.save': 'Guardar Aeronave',
    'fleet.form.cancel': 'Cancelar',

    'fleet.form.buttons.create': 'Crear Aeronave',
    'fleet.form.buttons.update': 'Actualizar Aeronave',
    'fleet.form.buttons.cancel': 'Cancelar',

    'fleet.form.fields.selectType': 'Seleccione el tipo',
    'fleet.form.fields.selectEngineType': 'Seleccione el tipo de motor',
    'fleet.form.fields.selectFuelType': 'Seleccione el tipo de combustible',
    'fleet.form.fields.tailNumber': 'Matrícula',
    'fleet.form.fields.type': 'Tipo de Aeronave',
    'fleet.form.fields.manufacturer': 'Fabricante',
    'fleet.form.fields.model': 'Modelo',
    'fleet.form.fields.year': 'Año',
    'fleet.form.fields.maxRange': 'Alcance Máximo (nm)',
    'fleet.form.fields.fuelType': 'Tipo de Combustible',
    'fleet.form.fields.fuelCapacity': 'Capacidad de Combustible (gal)',
    'fleet.form.fields.engineType': 'Tipo de Motor',
    'fleet.form.fields.location': 'Ubicación Actual',
    'fleet.form.fields.latitude': 'Latitud',
    'fleet.form.fields.longitude': 'Longitud',

    'fleet.list.columns.tailNumber': 'Matrícula',
    'fleet.list.columns.aircraft': 'Aeronave',
    'fleet.list.columns.year': 'Año',
    'fleet.list.columns.range': 'Alcance y Combustible',
    'fleet.list.columns.engine': 'Motor',
    'fleet.list.columns.actions': 'Acciones',
    'fleet.list.noAircraft': 'No hay aeronaves registradas aún.',

    'fleet.actions.viewOnMap': 'Ver en Mapa',
    'fleet.actions.edit': 'Editar',
    'fleet.actions.delete': 'Eliminar',

    // Reports & Analytics
    'reports.title': 'Informes y Análisis',
    'reports.subtitle': 'Ver métricas clave e información sobre sus operaciones',
    
    'reports.metrics.tripCount': 'Total de Viajes',
    'reports.metrics.activeTrips': 'Viajes Activos',
    'reports.metrics.tenderCount': 'Total de Licitaciones de Combustible',
    'reports.metrics.serviceTenderCount': 'Total de Licitaciones de Servicio',

    'reports.charts.tenderDistribution': 'Distribución de Licitaciones de Combustible',
    'reports.charts.serviceTenderDistribution': 'Distribución de Licitaciones de Servicio',
    'reports.charts.total': 'Total',

    'reports.status.pending': 'Pendiente',
    'reports.status.active': 'Activo',
    'reports.status.completed': 'Completado',
    'reports.status.cancelled': 'Cancelado',
    'reports.status.accepted': 'Aceptado',
    'reports.status.rejected': 'Rechazado',
    'reports.status.inProgress': 'En Proceso',

    'reports.errors.loadFailed': 'Error al cargar los datos. Por favor, intente nuevamente.',

    // Map Components
    'map.aircraft.title': 'Sus Aeronaves',

    'map.layers.title': 'Capas del Mapa',
    'map.layers.weather': 'Clima',
    'map.layers.weather.temperature': 'Temperatura',
    'map.layers.weather.clouds': 'Nubes',
    'map.layers.weather.precipitation': 'Precipitación',
    'map.layers.weather.wind': 'Viento',
    'map.layers.weather.pressure': 'Presión',
    'map.layers.mapFeatures': 'Características del Mapa',
    'map.layers.airports': 'Aeropuertos',
    'map.layers.alerts': 'Alertas',
    'map.layers.notams': 'NOTAMs',

    // Trip Components
    'trip.noActiveTrip': 'Sin Viaje Activo',
    'trip.newTrip': 'Nuevo Viaje',
    'trip.signInRequired': 'Inicie sesión para crear viajes',
    'trip.routes': 'Rutas',
    'trip.addRoute': 'Agregar Ruta',
    'trip.legs': 'Tramos',
    'trip.addLeg': 'Agregar Tramo',
    'trip.legCount_one': 'tramo',
    'trip.legCount_other': 'tramos',
    'trip.noRoutes': 'No se encontraron rutas',
    'trip.startNewTrip': 'Comience creando su primer viaje',
    'trip.createTrip': 'Crear Viaje',

    // Routes
    'routes.title': 'Rutas',
    'routes.newRoute': 'Nueva Ruta',
    'routes.legs': 'Tramos',
    'routes.addLeg': 'Agregar Tramo',
    'routes.legCount_one': 'tramo',
    'routes.legCount_other': 'tramos',
    'routes.status.scheduled': 'Programado',

    // Trip Management
    'trip.management.title': 'Gestión de Viajes',
    'trip.management.subtitle': 'Planifique y gestione sus viajes en múltiples modos de transporte.',
    'trip.management.newTrip': 'Nuevo Viaje',
    'trip.management.activeTrip': 'Viaje Activo',
    'trip.management.allTrips': 'Todos los Viajes',
    'trip.management.noTrips': 'No se encontraron viajes',
    'trip.management.startNewTrip': 'Comience creando su primer viaje',
    'trip.management.createTrip': 'Crear Viaje',

    'trip.form.title.new': 'Crear Nuevo Viaje',
    'trip.form.title.edit': 'Editar Viaje',
    'trip.form.fields.name': 'Nombre del Viaje',
    'trip.form.fields.description': 'Descripción',
    'trip.form.fields.startDate': 'Fecha de Inicio',
    'trip.form.fields.endDate': 'Fecha de Término',
    'trip.form.buttons.create': 'Crear Viaje',
    'trip.form.buttons.update': 'Actualizar Viaje',
    'trip.form.buttons.cancel': 'Cancelar',
    'trip.form.buttons.edit': 'Editar',

    'trip.status.planned': 'Planificado',
    'trip.status.active': 'Activo',
    'trip.status.completed': 'Completado',
    'trip.status.cancelled': 'Cancelado',
    'trip.status.setActive': 'Establecer como Activo',
    'trip.status.scheduled': 'Programado',
    'trip.status.departed': 'Partido',
    'trip.status.arrived': 'Llegado',

    'trip.routes.title': 'Rutas',
    'trip.routes.addRoute': 'Agregar Ruta',
    'trip.routes.legs': 'Tramos',
    'trip.routes.addLeg': 'Agregar Tramo',
    'trip.routes.noRoutes': 'No se encontraron rutas',
    'trip.routes.legCount_one': 'tramo',
    'trip.routes.legCount_other': 'tramos',

    'trip.route.form.title.new': 'Agregar Nueva Ruta',
    'trip.route.form.title.edit': 'Editar Ruta',
    'trip.route.form.fields.name': 'Nombre de la Ruta',
    'trip.route.form.fields.description': 'Descripción',
    'trip.route.form.fields.transitType': 'Tipo de Transporte',
    'trip.route.form.fields.selectTransitType': 'Seleccione el tipo de transporte',

    'trip.leg.form.title.new': 'Agregar Nuevo Tramo',
    'trip.leg.form.title.edit': 'Editar Tramo',
    'trip.leg.form.fields.origin': 'Origen',
    'trip.leg.form.fields.destination': 'Destino',
    'trip.leg.form.fields.scheduledDeparture': 'Salida Programada',
    'trip.leg.form.fields.scheduledArrival': 'Llegada Programada',
    'trip.leg.form.fields.notes': 'Notas',
    'trip.leg.form.fields.selectOrigin': 'Seleccione el origen',
    'trip.leg.form.fields.selectDestination': 'Seleccione el destino',

    'trip.leg.status.scheduled': 'Programado',
    'trip.leg.status.departed': 'Partido',
    'trip.leg.status.arrived': 'Llegado',
    'trip.leg.status.cancelled': 'Cancelado',

    'trip.errors.invalidDates': 'La fecha de término debe ser posterior a la fecha de inicio',
    'trip.errors.saveFailed': 'Error al guardar el viaje. Por favor, intente nuevamente.',
    'trip.errors.updateFailed': 'Error al actualizar el viaje. Por favor, intente nuevamente.',
    'trip.errors.deleteFailed': 'Error al eliminar el viaje. Por favor, intente nuevamente.',

    // Support Page
    'support.title': 'Soporte',
    'support.subtitle': 'Obtenga ayuda y gestione la configuración de su aplicación JetFlyt.',
    
    'support.cache.title': 'Gestión de Caché',
    'support.cache.description': 'Limpie el caché de la aplicación para obtener datos actualizados del servidor. Esto puede ayudar a resolver problemas de visualización.',
    'support.cache.refreshButton': 'Actualizar Datos',
    'support.cacheCleared': '¡Caché limpiado con éxito! La página se recargará.',
    
    'support.contact.title': 'Contacto de Soporte',
    'support.contact.description': '¿Necesita ayuda? Nuestro equipo de soporte está disponible 24/7 para ayudarlo.',
    'support.contact.email': 'Correo electrónico',
    'support.contact.phone': 'Teléfono',
    
    'support.docs.title': 'Documentación',
    'support.docs.description': 'Acceda a nuestra documentación completa y guías de usuario.',
    'support.docs.viewButton': 'Ver Documentación',

    // Auth
    'auth.signIn': 'Iniciar Sesión',
    'auth.signInDescription': 'Inicie sesión en su cuenta JetFlyt para gestionar sus licitaciones de combustible de aviación.',
    'auth.signInToJetFlyt': 'Iniciar Sesión en JetFlyt',
    'auth.createAccount': 'crear una nueva cuenta',
    'auth.or': 'O',
    'auth.emailAddress': 'Correo electrónico',
    'auth.password': 'Contraseña',
    'auth.signingIn': 'Iniciando sesión...',
    'auth.errors.requiredFields': 'Por favor complete todos los campos requeridos',
    'auth.errors.invalidCredentials': 'Correo electrónico o contraseña inválidos',
    'auth.errors.generalError': 'Ocurrió un error. Por favor intente nuevamente.',

    // Common
    'common.loading': 'Cargando...',
    'common.close': 'Cerrar',
    'common.notAvailable': 'N/D',

    'trip.routes.addRoute': 'Agregar Ruta',

    // Activity Logs
    'logs.title': 'Registros de Actividad',
    'logs.subtitle': 'Ver y seguir cambios en licitaciones y licitaciones FBO',
    'logs.tenderLogs': 'Registros de Licitaciones',
    'logs.fboTenderLogs': 'Registros de Licitaciones FBO',
    'logs.timestamp': 'Fecha y Hora',
    'logs.user': 'ID de Usuario',
    'logs.tender': 'Licitación',
    'logs.fbo': 'FBO',
    'logs.action': 'Acción',
    'logs.changes': 'Cambios',
  }
};