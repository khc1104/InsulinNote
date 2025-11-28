//
//  ModelError.swift
//  InsulinNote
//
//  Created by 권희철 on 11/28/25.
//
import Foundation

enum ModelError: LocalizedError {
    // 데이터 읽기 실패 -> 화면 대체 or 화면 새로고침 필요
    case fetchSettingError
    case fetchRecordError
    // 데이터 저장, 수정 실패 -> alert로 실패했음을 알려준 후 재시도 제안
    case updateDataError
    // 앱 첫 실행시 초기 세팅 설정이 실패 -> 앱을 완전히 제거 후 재설치 필요
    case createInitSettingError
    
    var errorDescription: String? {
        switch self {
        case .fetchSettingError: return "인슐린 정보 불러오기 실패"
        case .fetchRecordError: return "투여 기록 불러오기 실패"
        case .updateDataError: return "저장 실패"
        case .createInitSettingError: return "초기 설정 생성 실패"
        }
    }
    var recoverSuggestion: String? {
        switch self {
        case .fetchSettingError, .fetchRecordError:
            return "페이지를 새로고침해주세요. 문제가 지속될 경우 앱을 다시 시작해주세요."
        case .updateDataError:
            return "다시 시도해주세요. 문제가 지속될 경우 앱을 다시 시작해주세요."
        case .createInitSettingError:
            return "앱을 완전히 삭제한 후 재설치를 해주세요."
        }
    }
}
