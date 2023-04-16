import SwiftUI
import UniformTypeIdentifiers

struct FilePickerView: View {
    @State var filename = ""
    @State var fileData: [[String]] = []

    var body: some View {
        VStack {
            HStack {
                Text(filename)
                Button("Select File")
                {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    panel.allowedContentTypes = [UTType("public.comma-separated-values-text")].compactMap { $0 }
                    if panel.runModal() == .OK {
                        self.filename = panel.url?.lastPathComponent ?? "<none>"
                        do {
                            let fileContents = try String(contentsOf: panel.url!)
                            self.fileData = parseCSV(fileContents: fileContents)
                        } catch {
                            print("Error reading file: \(error.localizedDescription)")
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            List(fileData, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { cell in
                        Text(cell)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }

    func parseCSV(fileContents: String) -> [[String]] {
        var result: [[String]] = []
        let rows = fileContents.components(separatedBy: "\n")
        for row in rows {
            let cells = row.components(separatedBy: ",")
            result.append(cells)
        }
        return result
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilePickerView()
    }
}

