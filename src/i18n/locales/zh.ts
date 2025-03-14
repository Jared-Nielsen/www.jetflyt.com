export const zh = {
  translation: {
    // Navigation
    'nav.tenders': '投标',
    'nav.handling': '地面服务',
    'nav.fleet': '机队',
    'nav.reports': '报告',
    'nav.signIn': '登录',
    'nav.signOut': '退出',

    // Landing Page
    'landing.title': '航空燃料投标管理',
    'landing.subtitle': '优化您的航空燃料采购流程',
    'landing.auth.signInCta': '登录访问 →',
    
    'landing.features.tenders.title': '提交投标',
    'landing.features.tenders.description': '轻松创建和提交年度燃料合同报价。',
    
    'landing.features.handling.title': '地面服务',
    'landing.features.handling.description': '提交地面服务投标。',
    
    'landing.features.fleet.title': '机队管理',
    'landing.features.fleet.description': '注册和管理您的机队信息。',
    
    'landing.features.reports.title': '报告',
    'landing.features.reports.description': '查看运营分析和见解。',

    // Tender Management
    'tenders.title': '投标',
    'tenders.subtitle': '在多个FBO创建和管理您的燃料投标。',
    'tenders.newTender': '新建投标',
    
    'tenders.status.title': '状态',
    'tenders.status.pending': '待处理',
    'tenders.status.active': '活动',
    'tenders.status.accepted': '已接受',
    'tenders.status.rejected': '已拒绝',
    'tenders.status.canceled': '已取消',

    'tenders.details.title': '投标详情',
    'tenders.details.created': '创建于',
    'tenders.details.aircraft': '飞机',
    'tenders.details.location': '位置',
    'tenders.details.fuelRequest': '燃料请求',
    'tenders.details.bestPrice': '当前最优价格',
    'tenders.details.fboResponses': 'FBO响应',
    'tenders.details.description': '描述',
    'tenders.details.totalValue': '总价值',
    'tenders.details.tenderId': '投标ID',

    'tenders.offers.columns.fbo': 'FBO',
    'tenders.offers.columns.location': '位置',
    'tenders.offers.columns.offerPrice': '报价',
    'tenders.offers.columns.totalCost': '总成本',
    'tenders.offers.columns.taxesAndFees': '税费',
    'tenders.offers.columns.finalCost': '最终成本',
    'tenders.offers.columns.actions': '操作',

    'tenders.offers.buttons.accept': '接受',
    'tenders.offers.buttons.sendContract': '发送合同',
    'tenders.offers.buttons.close': '关闭',
    'tenders.offers.buttons.cancel': '取消',

    'tenders.offers.status.canceled': '已取消',

    'tenders.offers.modal.contractTitle': '合同确认',
    'tenders.offers.modal.contractSent': '合同已发送至 {{fbo}}',

    'tenders.offers.errors.acceptFailed': '接受报价失败。请重试。',

    'tenders.offers.noResponses': '未找到投标报价。',
    'tenders.offers.response': '响应',
    'tenders.offers.responses': '响应',

    'tenders.form.title.new': '创建新投标',
    'tenders.form.title.edit': '编辑投标',
    'tenders.form.title.cancel': '取消投标',

    'tenders.form.fields.aircraft': '飞机',
    'tenders.form.fields.selectAircraft': '选择飞机',
    'tenders.form.fields.airport': '机场',
    'tenders.form.fields.selectAirport': '选择机场',
    'tenders.form.fields.gallons': '所需加仑数',
    'tenders.form.fields.targetPrice': '目标价格',
    'tenders.form.fields.annual': '年度',
    'tenders.form.fields.startDate': '开始日期',
    'tenders.form.fields.endDate': '结束日期（可选）',
    'tenders.form.fields.description': '描述',
    'tenders.form.fields.selectFbos': '选择要发送投标的FBO',

    'tenders.form.buttons.cancel': '取消',
    'tenders.form.buttons.create': '创建投标',
    'tenders.form.buttons.update': '更新投标',
    'tenders.form.buttons.creating': '创建中...',
    'tenders.form.buttons.edit': '编辑',
    'tenders.form.buttons.cancelTender': '取消投标',
    'tenders.form.buttons.close': '关闭',
    'tenders.form.buttons.keepIt': '否，保留',
    'tenders.form.buttons.cancelling': '取消中...',
    'tenders.form.buttons.confirmCancel': '是，取消投标',

    'tenders.form.confirmCancel': '确定要取消此投标吗？此操作无法撤消。',

    'tenders.form.errors.invalidDates': '结束日期必须晚于开始日期',
    'tenders.form.errors.noFboSelected': '请至少选择一个FBO',

    // Ground Handling
    'handling.title': '地面服务',
    'handling.subtitle': '创建和管理您的地面服务请求。',
    'handling.newServiceTender': '新建服务投标',
    'handling.noServiceTenders': '未找到服务投标。',

    'handling.details.title': '服务投标详情',
    'handling.details.created': '已创建',
    'handling.details.arrival': '到达',
    'handling.details.departure': '出发',
    'handling.details.service': '服务',
    'handling.details.quantity': '数量',
    'handling.details.requestedDate': '请求日期',
    'handling.details.completedDate': '完成日期',
    'handling.details.description': '描述',
    'handling.details.passengerInfo': '乘客信息',
    'handling.details.passengers': '乘客',
    'handling.details.crew': '机组',
    'handling.details.pets': '宠物',

    'handling.list.columns.aircraft': '飞机',
    'handling.list.columns.service': '服务',
    'handling.list.columns.fboLocations': 'FBO位置',
    'handling.list.columns.description': '描述',
    'handling.list.columns.status': '状态',
    'handling.list.fboLocations': 'FBO位置',
    'handling.list.fboCount_one': 'FBO',
    'handling.list.fboCount_other': 'FBO',

    'handling.status.pending': '待处理',
    'handling.status.accepted': '已接受',
    'handling.status.inProgress': '进行中',
    'handling.status.completed': '已完成',
    'handling.status.canceled': '已取消',

    'handling.form.title.new': '创建新服务投标',
    'handling.form.title.edit': '编辑服务投标',

    'handling.form.fields.aircraft': '飞机',
    'handling.form.fields.selectAircraft': '选择飞机',
    'handling.form.fields.airport': '机场',
    'handling.form.fields.selectAirport': '选择机场',
    'handling.form.fields.service': '服务',
    'handling.form.fields.selectService': '选择服务',
    'handling.form.fields.quantity': '数量',
    'handling.form.fields.description': '描述',
    'handling.form.fields.requestedDate': '请求日期',
    'handling.form.fields.arrivalDate': '到达日期（可选）',
    'handling.form.fields.departureDate': '出发日期（可选）',
    'handling.form.fields.selectFbos': '选择FBO',
    'handling.form.fields.passengerCount': '乘客数量',
    'handling.form.fields.crewCount': '机组人数',
    'handling.form.fields.petCount': '宠物数量',

    'handling.form.buttons.cancel': '取消',
    'handling.form.buttons.create': '创建投标',
    'handling.form.buttons.update': '更新投标',
    'handling.form.buttons.edit': '编辑',
    'handling.form.buttons.cancelTender': '取消投标',
    'handling.form.errors.invalidDates': '出发日期必须晚于到达日期',
    'handling.form.errors.noFboSelected': '请至少选择一个FBO',
    'handling.form.errors.noRequestedDate': '请求日期为必填项',
    'handling.form.errors.submissionFailed': '提交表单失败。请重试。',

    // Footer
    'footer.about.title': '关于JetFlyt',
    'footer.about.description': '通过创新的投标管理解决方案优化航空燃料采购。',
    'footer.quickLinks.title': '快速链接',
    'footer.quickLinks.fboMap': 'FBO地图',
    'footer.quickLinks.airports': '机场',
    'footer.quickLinks.dispatch': '调度',
    'footer.quickLinks.support': '支持',
    'footer.legal.title': '法律',
    'footer.legal.privacy': '隐私政策',
    'footer.legal.terms': '条款和条件',
    'footer.contact.title': '联系我们',
    'footer.contact.contactUs': '联系我们',
    'footer.copyright': '© {{year}} JetFlyt。保留所有权利。',

    // Fleet Management
    'fleet.title': '机队管理',
    'fleet.subtitle': '管理您的机队信息和规格。',
    'fleet.addAircraft': '添加飞机',
    'fleet.uploadExcel': '上传Excel',
    'fleet.downloadTemplate': '下载模板',
    'fleet.confirmDelete': '确定要删除这架飞机吗？',
    'fleet.uploadSuccess': '飞机数据上传成功',
    'fleet.errors.saveFailed': '保存飞机失败。请重试。',
    'fleet.errors.deleteFailed': '删除飞机失败。请重试。',
    'fleet.errors.uploadFailed': '上传数据失败。请检查格式后重试。',

    // Aircraft Details
    'fleet.details.title': '飞机详情',
    'fleet.details.registration': '注册号',
    'fleet.details.edit': '编辑',
    'fleet.details.viewOnMap': '在地图上查看',
    'fleet.details.aircraftType': '飞机类型',
    'fleet.details.manufacturer': '制造商',
    'fleet.details.year': '年份',
    'fleet.details.engineType': '发动机类型',
    'fleet.details.fuelType': '燃料类型',
    'fleet.details.fuelCapacity': '燃料容量',
    'fleet.details.maxRange': '最大航程',
    'fleet.details.currentLocation': '当前位置',
    'fleet.details.locationNotSet': '位置未设置',
    'fleet.details.modelPreview': '3D模型预览',

    'fleet.form.add': '添加新飞机',
    'fleet.form.edit': '编辑飞机',
    'fleet.form.save': '保存飞机',
    'fleet.form.cancel': '取消',

    'fleet.form.buttons.create': '创建飞机',
    'fleet.form.buttons.update': '更新飞机',
    'fleet.form.buttons.cancel': '取消',

    'fleet.form.fields.selectType': '选择类型',
    'fleet.form.fields.selectEngineType': '选择发动机类型',
    'fleet.form.fields.selectFuelType': '选择燃料类型',
    'fleet.form.fields.tailNumber': '注册号',
    'fleet.form.fields.type': '飞机类型',
    'fleet.form.fields.manufacturer': '制造商',
    'fleet.form.fields.model': '型号',
    'fleet.form.fields.year': '年份',
    'fleet.form.fields.maxRange': '最大航程 (nm)',
    'fleet.form.fields.fuelType': '燃料类型',
    'fleet.form.fields.fuelCapacity': '燃料容量 (gal)',
    'fleet.form.fields.engineType': '发动机类型',
    'fleet.form.fields.location': '当前位置',
    'fleet.form.fields.latitude': '纬度',
    'fleet.form.fields.longitude': '经度',

    'fleet.list.columns.tailNumber': '注册号',
    'fleet.list.columns.aircraft': '飞机',
    'fleet.list.columns.year': '年份',
    'fleet.list.columns.range': '航程和燃料',
    'fleet.list.columns.engine': '发动机',
    'fleet.list.columns.actions': '操作',
    'fleet.list.noAircraft': '尚未注册飞机。',

    'fleet.actions.viewOnMap': '在地图上查看',
    'fleet.actions.edit': '编辑',
    'fleet.actions.delete': '删除',

    // Reports & Analytics
    'reports.title': '报告和分析',
    'reports.subtitle': '查看关键指标和运营洞察',
    
    'reports.metrics.tripCount': '总航班数',
    'reports.metrics.activeTrips': '活动航班',
    'reports.metrics.tenderCount': '燃料投标总数',
    'reports.metrics.serviceTenderCount': '服务投标总数',

    'reports.charts.tenderDistribution': '燃料投标分布',
    'reports.charts.serviceTenderDistribution': '服务投标分布',
    'reports.charts.total': '总计',

    'reports.status.pending': '待处理',
    'reports.status.active': '活动中',
    'reports.status.completed': '已完成',
    'reports.status.cancelled': '已取消',
    'reports.status.accepted': '已接受',
    'reports.status.rejected': '已拒绝',
    'reports.status.inProgress': '进行中',

    'reports.errors.loadFailed': '加载数据失败。请重试。',

    // Common
    'common.loading': '加载中...',
    'common.close': '关闭',
    'common.notAvailable': '不可用',

    'trip.routes.addRoute': '添加路线',

    // Activity Logs
    'logs.title': '活动日志',
    'logs.subtitle': '查看和跟踪投标和FBO投标的变更',
    'logs.tenderLogs': '投标日志',
    'logs.fboTenderLogs': 'FBO投标日志',
    'logs.timestamp': '时间戳',
    'logs.user': '用户ID',
    'logs.tender': '投标',
    'logs.fbo': 'FBO',
    'logs.action': '操作',
    'logs.changes': '变更',
  }
};