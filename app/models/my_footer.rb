class MyFooter < ActiveAdmin::Component
  def build?
    super(id: "footer")
    para "Copyright #{Date.today.year} Reverb Media Group"
  end
end