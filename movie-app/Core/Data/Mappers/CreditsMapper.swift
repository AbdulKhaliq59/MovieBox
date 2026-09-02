nonisolated enum CreditsMapper {
    static func map(_ dto: CastMemberDTO) -> CastMember {
        CastMember(id: dto.id, name: dto.name, character: dto.character, profilePath: dto.profilePath)
    }

    static func map(_ dtos: [CastMemberDTO]) -> [CastMember] {
        dtos.map(map)
    }
}
