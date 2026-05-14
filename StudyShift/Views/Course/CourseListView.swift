//
//  Untitled.swift
//  StudyShift
//
//  Created by Chelvin Alexyus on 12/5/2026.
//
import SwiftUI
import SwiftData

struct CourseListView: View {
    @Query(sort: \Course.name) private var courses: [Course]
    
    @State private var showAddCourseSheet = false

    var body: some View {
        ZStack {
            Color.tealMain
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header

                    if courses.isEmpty {
                        Text("No courses yet")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.surfaceCard)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        ForEach(courses) { course in
                            NavigationLink {
                                CourseDetailView(course: course)
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("\(course.code) \(course.name)")
                                        .font(.headline)

                                    Text("Target: \(course.targetGrade.rawValue)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(18)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.surfaceCard)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color(hex: course.colorHex).opacity(0.45), lineWidth: 2)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddCourseSheet) {
            AddCourseView()
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Course List")
                    .font(.title3.bold())
                
                

//                Text("Semester 3 | 2026")
//                    .font(.caption)
            }

            Spacer()

            Button {
                showAddCourseSheet = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black)
                    .padding(10)
                    .background(Color.surfaceCard)
                    .clipShape(Circle())
            }
//            Image(systemName: "bell")
//                .padding(8)
//                .background(.white)
//                .clipShape(Circle())
        }
        .foregroundStyle(.black)
    }
}


#Preview {
    CourseListView()
        .modelContainer(ModelContainerFactory.createPreviewContainer())
}
